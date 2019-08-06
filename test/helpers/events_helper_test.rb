require 'test_helper'

class EventsHelperTest < ActionView::TestCase
  setup do
    @event = Event.fourth
    @competition = Competition.first
    @event_assignment = Assignment.fourth
  end

  test 'participant_able_to_enter?' do
    assert_not participant_able_to_enter?
  end
end
