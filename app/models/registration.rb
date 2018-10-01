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
    event.check_for_newly_freed_space
  end
end
