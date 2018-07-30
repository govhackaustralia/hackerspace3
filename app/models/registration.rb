class Registration < ApplicationRecord
  belongs_to :assignment
  has_one :user, through: :assignment
  belongs_to :event

  after_update :check_for_newly_freed_space

  validates :status, presence: true
  validates :status, inclusion: { in: VALID_ATTENDANCE_STATUSES }
  validates :assignment_id, uniqueness: { scope: :event_id,
                                          message: 'Registration already exists' }

  private

  def check_for_newly_freed_space
    event = self.event
    return unless event.below_capacity?
    waitlist_registrations = event.registrations.where(status: WAITLIST).order(time_notified: :asc)
    return unless (new_attendee = waitlist_registrations.first).present?
    # START TRANSACTION
      new_attendee.update(status: ATTENDING)
      # SEND MAIL
    # END TRANSACTION
  end
end
