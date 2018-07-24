require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    @event = Event.first
    @region = Region.second
    @competition = Competition.first
    @assignment = Assignment.third
    @user = User.first
  end

  test 'event associations' do
    assert(@event.region == @region)
    assert(@event.competition == @competition)
    assert(@event.assignments.include?(@assignment))
  end

  test 'test validations' do
    # No name
    assert_not(Event.create(name: nil).persisted?)
    # Duplicate Name
    assert_not(Event.create(name: @event.name).persisted?)
  end
end
