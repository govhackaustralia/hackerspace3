class Event < ApplicationRecord
  has_many :assignments, as: :assignable
  has_many :registrations, dependent: :destroy
  has_many :registration_assignments, through: :registrations, source: :assignment
  belongs_to :region
  belongs_to :competition
  has_one :event_partnership
  has_one :event_partner, through: :event_partnership, source: :sponsor

  validates :name, :capacity, :registration_type, :category_type, presence: true

  validates :registration_type, inclusion: { in: EVENT_REGISTRATION_TYPES }
  validates :category_type, inclusion: { in: EVENT_CATEGORY_TYPES }

  after_save :update_identifier

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

  private

  def update_identifier
    new_identifier = uri_pretty("#{category_type}-#{name}")
    if Event.find_by_identifier(new_identifier).present?
      new_identifier = uri_pretty("#{category_type}-#{name}-#{id}")
    end
    update_columns(identifier: new_identifier)
  end

  def uri_pretty(string)
    array = string.split(/\W/)
    words = array - ['']
    new_name = words.join('_')
    CGI.escape(new_name.downcase)
  end
end
