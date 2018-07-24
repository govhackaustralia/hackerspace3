class Attendance < ApplicationRecord
  belongs_to :assignment
  belongs_to :event

  validates :status, presence: true
  validates :status, inclusion: { in: VALID_ATTENDANCE_STATUSES }
end
