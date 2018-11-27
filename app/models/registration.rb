class Registration < ApplicationRecord
  belongs_to :assignment
  has_one :user, through: :assignment
  belongs_to :event
  has_many :registration_flights, dependent: :destroy
  has_many :flights, through: :registration_flights

  after_update :check_for_newly_freed_space

  validates :status, presence: true
  validates :status, inclusion: { in: VALID_ATTENDANCE_STATUSES }
  validates :assignment_id, uniqueness: { scope: :event_id,
                                          message: 'Registration already exists' }

  def category
    reg_assignment = assignment
    if reg_assignment.title == VIP || assignment.title == PARTICIPANT
      return REGULAR
    elsif reg_assignment.assignable_type == 'Team'
      return GROUP_GOLDEN
    elsif reg_assignment.title == GOLDEN_TICKET
      return INDIVIDUAL_GOLDEN
    else
      return STAFF
    end
  end

  def inbound_flight
    flights.find_by(direction: INBOUND)
  end

  def outbound_flight
    flights.find_by(direction: OUTBOUND)
  end

  private

  def check_for_newly_freed_space
    event.check_for_newly_freed_space
  end
end
