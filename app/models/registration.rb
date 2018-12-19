class Registration < ApplicationRecord
  belongs_to :assignment
  belongs_to :event

  has_one :user, through: :assignment

  has_many :registration_flights, dependent: :destroy
  has_many :flights, through: :registration_flights

  scope :attending, -> { where(status: ATTENDING) }
  scope :waitlist, -> { where(status: WAITLIST) }
  scope :non_attending, -> { where(status: NON_ATTENDING) }

  after_update :check_for_newly_freed_space

  validates :status, presence: true
  validates :status, inclusion: { in: VALID_ATTENDANCE_STATUSES }
  validates :assignment_id, uniqueness: { scope: :event_id,
                                          message: 'Registration already exists' }

  # Returns the category of a registration for the purpose of allocating
  # different event ticket types.
  def category
    reg_assignment = assignment
    if [PARTICIPANT, VIP].include? reg_assignment
      REGULAR
    elsif reg_assignment.assignable_type == 'Team'
      GROUP_GOLDEN
    elsif reg_assignment.title == GOLDEN_TICKET
      INDIVIDUAL_GOLDEN
    else
      STAFF
    end
  end

  # Return the inbound flight chosen by a registraton.
  # ENHANCEMENT: Move into rails associations
  def inbound_flight
    flights.inbound
  end

  # Return the outbound flight chosen by a registraton.
  # ENHANCEMENT: Move into rails associations
  def outbound_flight
    flights.outbound
  end

  private

  # Triggers call back to check for space in an event, usually for someone else.
  # ENHANCEMENT: Probably bad practice.
  def check_for_newly_freed_space
    event.check_for_newly_freed_space
  end
end
