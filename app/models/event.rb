class Event < ApplicationRecord
  has_many :assignments, as: :assignable, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :registration_assignments, through: :registrations, source: :assignment
  belongs_to :region
  belongs_to :competition
  has_one :event_partnership, dependent: :destroy
  has_one :event_partner, through: :event_partnership, source: :sponsor
  has_many :teams
  has_many :entries, through: :teams
  has_many :flights
  has_many :bulk_mails, as: :mailable, dependent: :destroy

  validates :name, :capacity, presence: true
  validates :registration_type, inclusion: { in: EVENT_REGISTRATION_TYPES }
  validates :event_type, inclusion: { in: EVENT_TYPES }

  after_save :update_identifier
  after_update :check_for_newly_freed_space

  # Event Administration

  def host_user
    assignment = Assignment.find_by(title: EVENT_HOST, assignable: self)
    return nil if assignment.nil?
    assignment.user
  end

  def support_users
    support_ids = assignments.where(title: EVENT_SUPPORT).pluck(:user_id)
    User.where(id: support_ids)
  end

  def admin_assignments
    collected = assignments.where(title: EVENT_ADMIN).to_a
    collected << region.admin_assignments
    collected << competition.admin_assignments
    collected.flatten
  end

  def admin_privileges?(user)
    (admin_assignments & user.assignments).present?
  end

  # Event Registrations

  def attending?(event_assignment)
    Registration.find_by(assignment: event_assignment, status: ATTENDING, event: self).present?
  end

  def waitlisted?(event_assignment)
    Registration.find_by(assignment: event_assignment, status: WAITLIST, event: self).present?
  end

  def not_attending?(event_assignment)
    Registration.find_by(assignment: event_assignment, status: NON_ATTENDING, event: self).present?
  end

  def at_capacity?
    attending_participants_count >= capacity
  end

  def below_capacity?
    attending_participants_count < capacity
  end

  def waitlist?
    Registration.find_by(status: WAITLIST, event: self).present?
  end

  def attending_participants_count
    attending_ids = registrations.where(status: ATTENDING).pluck(:assignment_id)
    vip_ids = registration_assignments.where(title: VIP).pluck(:id)
    (attending_ids - vip_ids).count
  end

  def closed?
    registration_type == CLOSED
  end

  def update_identifier
    new_identifier = uri_pritty("#{name}-#{region.name}")
    if already_there?(new_identifier)
      new_identifier = uri_pritty("#{name}-#{region.name}-#{id}")
    end
    update_columns(identifier: new_identifier)
  end

  def competition_event?
    event_type == COMPETITION_EVENT
  end

  def self.to_csv(options = {})
    desired_columns = %w[id name capacity email twitter address accessibility youth_support parking public_transport operation_hours catering video_id start_time end_time created_at updated_at place_id identifier event_type]
    CSV.generate(options) do |csv|
      csv << desired_columns
      all.each do |event|
        csv << event.attributes.values_at(*desired_columns)
      end
    end
  end

  def registrations_to_csv(options = {})
    user_columns = %w[full_name preferred_name organisation_name dietary_requirements registration_type parent_guardian request_not_photographed data_cruncher coder creative facilitator]
    combined = user_columns + ['status']
    CSV.generate(options) do |csv|
      csv << combined
      registrations.all.each do |registration|
        user_values = registration.user.attributes.values_at(*user_columns)
        csv << user_values + [registration.status]
      end
    end
  end

  def self.id_events(events)
    events = where(id: events.uniq) if events.class == Array
    id_events = {}
    events.each { |event| id_events[event.id] = event }
    id_events
  end

  def check_for_newly_freed_space
    ActiveRecord::Base.transaction do
      return unless below_capacity?
      waitlist_registrations = registrations.where(status: WAITLIST).order(time_notified: :asc)
      return unless (new_attendee = waitlist_registrations.first).present?
      new_attendee.update(status: ATTENDING)
      RegistrationMailer.attendance_email(new_attendee).deliver_now
    end
  end

  def inbound_flights
    flights.where(direction: INBOUND)
  end

  def outbound_flights
    flights.where(direction: OUTBOUND)
  end

  private

  def already_there?(new_identifier)
    event = Event.find_by(identifier: new_identifier)
    return false if event.nil?
    return false if event == self
    true
  end

  def uri_pritty(string)
    array = string.split(/\W/)
    words = array - ['']
    new_name = words.join('_')
    CGI.escape(new_name.downcase)
  end
end
