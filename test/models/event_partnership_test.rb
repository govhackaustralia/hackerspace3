require 'test_helper'

class EventPartnershipTest < ActiveSupport::TestCase
  setup do
    @event_partnership = EventPartnership.first
    @event = events(:connection)
    @sponsor = sponsors(:one)
  end

  test 'event partnership associations' do
    assert @event_partnership.event == @event
    assert @event_partnership.sponsor == @sponsor
  end
end
