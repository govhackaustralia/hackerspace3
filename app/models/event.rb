class Event < ApplicationRecord
  belongs_to :region
  has_one :competition, through: :region

  has_many :assignments, as: :assignable, dependent: :destroy

  has_many :host_assignments, -> { event_hosts }, class_name: 'Assignment', as: :assignable
  has_many :event_hosts, through: :host_assignments, source: :user

  has_many :support_assignments, -> { event_supports }, class_name: 'Assignment', as: :assignable
  has_many :event_supports, through: :support_assignments, source: :user

  has_many :registrations, dependent: :destroy

  has_many :participant_registrations, -> { participants }, class_name: 'Registration'
  has_many :vip_registrations, -> { vips }, class_name: 'Registration'

  has_many :teams
  has_many :entries, through: :teams
  has_many :projects_by_name, -> { order :project_name }, through: :teams, source: :current_project

  has_many :published_teams, -> { published }, class_name: 'Team'
  has_many :published_projects_by_name, -> { order :project_name }, through: :published_teams, source: :current_project

  has_many :bulk_mails, as: :mailable, dependent: :destroy

  has_one :event_partnership, dependent: :destroy
  has_one :event_partner, through: :event_partnership, source: :sponsor

  has_many :flights, dependent: :destroy
  has_many :inbound_flights, -> { inbound }, class_name: 'Flight'
  has_many :outbound_flights, -> { outbound }, class_name: 'Flight'

  scope :published, -> { where published: true }

  scope :past, lambda {
    where 'end_time < ?', Time.now.in_time_zone(COMP_TIME_ZONE)
  }
  scope :future, lambda {
    where 'start_time > ?', Time.now.in_time_zone(COMP_TIME_ZONE)
  }

  scope :connections, -> { where event_type: CONNECTION_EVENT }
  scope :competitions, -> { where event_type: COMPETITION_EVENT }
  scope :awards, -> { where event_type: AWARD_EVENT }

  scope :locations, lambda {
    where 'events.name NOT LIKE ? AND event_type = ?',
          '%Remote%', COMPETITION_EVENT
  }
  scope :remotes, lambda {
    where 'events.name LIKE ? AND event_type = ?',
          '%Remote%', COMPETITION_EVENT
  }

  scope :competition, lambda { |competition|
    joins(:region).where(regions: { competition: competition })
  }

  validates :name, :capacity, presence: true
  validates :registration_type, inclusion: { in: EVENT_REGISTRATION_TYPES }
  validates :event_type, inclusion: { in: EVENT_TYPES }

  after_save :update_identifier

  after_update :check_for_newly_freed_space

  # Event Administration

  # Returns the user record associated with the Event Host.
  # ENHANCEMENT: Remove and enforce single event host with validation.
  def event_host
    event_hosts.first
  end

  # Returns all the admin assignments allowed to modify this record.
  # ENHANCEMENT: Perhaps can be moved into single DB query?
  # ENHANCEMENT: Move to Helper
  def admin_assignments
    collected = assignments.where(title: EVENT_ADMIN).to_a
    collected << region.admin_assignments
    collected << competition.admin_assignments
    collected.flatten
  end

  # Returns true if a given user has an assignment that is able to edit the
  # event record. False otherwise.
  # ENHANCEMENT: Move to Helper
  def admin_privileges?(user)
    (admin_assignments & user.assignments).present?
  end

  # Event Registrations

  # Returns true if a given event assignment is attending the event, false
  # otherwise.
  # ENHANCEMENT: Move to Helper
  def attending?(event_assignment)
    registrations.attending.find_by(assignment: event_assignment).present?
  end

  # Returns true if a given event assignment is waitlisted for the event, false
  # otherwise
  # ENHANCEMENT: Move to Helper
  def waitlisted?(event_assignment)
    registrations.waitlist.find_by(assignment: event_assignment).present?
  end

  # Returns true if a given event assignment is not attending the event, false
  # otherwise
  # ENHANCEMENT: Move to Helper
  def not_attending?(event_assignment)
    registrations.non_attending.find_by(assignment: event_assignment).present?
  end

  # Returns true if the attending registrations (minus VIPs) for an event are
  # greater than or equal to the capacity of the event. False otherwise.
  # ENHANCEMENT: Move to Helper
  def at_capacity?
    attending_participants_count >= capacity
  end

  # Returns true if the attending registrations (minus VIPs) for an event are
  # less than the capacity of the event. False otherwise.
  # ENHANCEMENT: Move to Helper
  def below_capacity?
    attending_participants_count < capacity
  end

  # Returns true if the event has a waitlist, false otherwise.
  # ENHANCEMENT: Move to Helper
  def waitlist?
    registrations.waitlist.present?
  end

  # Returns the number of registrations belongs to non VIPs registered as
  # attending.
  # ENHANCEMENT: Move to Helper
  def attending_participants_count
    participant_registrations.attending.count
  end

  # Returns true if an event has registration type 'closed', false otherwise.
  def closed?
    registration_type == CLOSED
  end

  def finished?
    Time.now.in_time_zone(COMP_TIME_ZONE) > end_time
  end

  # Returns true if an event has registration type 'competition', false
  # otherwise
  def competition_event?
    event_type == COMPETITION_EVENT
  end

  # Return true if an event is not a remote event, false otherwise
  def not_remote_event?
    name.exclude? 'Remote'
  end

  # Return a CSV file of event attributes.
  def self.to_csv(competition, options = {})
    desired_columns = %w[id name capacity email twitter address accessibility youth_support parking public_transport operation_hours catering video_id start_time end_time created_at updated_at place_id identifier event_type]
    CSV.generate(options) do |csv|
      csv << desired_columns
      competition.events.each do |event|
        csv << event.attributes.values_at(*desired_columns)
      end
    end
  end

  # Returns a CSV file of Registrations associated with an event.
  def registrations_to_csv(options = {})
    user_columns = %w[full_name preferred_name organisation_name dietary_requirements registration_type parent_guardian request_not_photographed data_cruncher coder creative facilitator]
    combined = user_columns + ['status']
    CSV.generate(options) do |csv|
      csv << combined
      registrations.each do |registration|
        user_values = registration.user.attributes.values_at(*user_columns)
        csv << user_values + [registration.status]
      end
    end
  end

  # Checks if the event is under capacity and if so, will take registrations
  # off the waiting list.
  def check_for_newly_freed_space
    ActiveRecord::Base.transaction do
      return unless below_capacity?

      waitlist_registrations = registrations.where(status: WAITLIST).order(time_notified: :asc)
      return unless (new_attendee = waitlist_registrations.first).present?

      new_attendee.update(status: ATTENDING)
      return if %w[development test].include? ENV['RAILS_ENV']

      RegistrationMailer.attendance_email(new_attendee).deliver_later
    end
  end

  private

  # Generates a unique name and updates the identifier field.
  def update_identifier
    new_identifier = uri_pritty "#{name}-#{region.name}"
    new_identifier = uri_pritty "#{name}-#{region.name}-#{id}" if already_there? Event, new_identifier, self
    update_columns identifier: new_identifier
  end
end
