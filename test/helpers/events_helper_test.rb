require 'test_helper'

class EventsHelperTest < ActionView::TestCase
  setup do
    @event = Event.fourth
    @competition = Competition.first
    @region = regions(:regional)
    @event_assignment = Assignment.fourth
  end

  test 'participant_able_to_enter?' do
    assert_not participant_able_to_enter?
  end

  test 'event_registration_closed?' do
    @event.end_time = Time.now - 1.hour
    assert event_registration_closed?(@event, @region, @competition)
    @event.end_time = Time.now + 1.hour
    assert_not event_registration_closed?(@event, @region, @competition)
  end
end
