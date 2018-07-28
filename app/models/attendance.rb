class Attendance < ApplicationRecord
  belongs_to :assignment
  has_one :user, through: :assignment
  belongs_to :event

  validates :status, presence: true
  validates :status, inclusion: { in: VALID_ATTENDANCE_STATUSES }
  validates :assignment_id, uniqueness: { scope: :event_id,
                                          message: 'Registration already exists' }
end
