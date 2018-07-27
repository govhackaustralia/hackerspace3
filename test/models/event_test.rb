require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    @event = Event.first
    @region = Region.second
    @competition = Competition.first
    @assignment = Assignment.third
    @attendance = Attendance.find(1)
    @user = User.first
    @sponsorship = Sponsorship.first
  end

  test 'event associations' do
    assert(@event.region == @region)
    assert(@event.competition == @competition)
    assert(@event.assignments.include?(@assignment))
    assert(@event.attendances.include?(@attendance))
    assert(@event.attendance_assignments.include?(@attendance.assignment))
    assert(@event.sponsorships.include?(@sponsorship))
  end

  test 'event validations' do
    # No name
    assert_not(Event.create(name: nil).persisted?)
    # Duplicate Name
    assert_not(Event.create(name: @event.name).persisted?)
  end

  test 'attending method' do
    assert(@event.attending(@user))
  end
end
