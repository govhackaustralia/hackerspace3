require 'test_helper'

class AttendanceTest < ActiveSupport::TestCase
  setup do
    @assignment = Assignment.find(4)
    @attendance = Attendance.find(1)
    @event = Event.find(1)
    @user = User.first
  end

  test 'attendance associations' do
    assert(@attendance.assignment == @assignment)
    assert(@attendance.event == @event)
    assert(@attendance.user == @user)
  end

  test 'attendance validations' do
    @attendance.destroy
    # Must have status
    new_attendance = @event.attendances.create(assignment: @assignment, status: nil)
    assert_not(new_attendance.persisted?)
    # non valid status
    new_attendance = @event.attendances.create(assignment: @assignment, status: 'Maybe')
    assert_not(new_attendance.persisted?)
    # valid status
    new_attendance = @event.attendances.create(assignment: @assignment, status: VALID_ATTENDANCE_STATUSES.first)
    assert(new_attendance.persisted?)
  end
end
