require 'test_helper'

class SponsorshipTest < ActiveSupport::TestCase
  setup do
    @event_sponsorship = Sponsorship.first
    @region_sponsorship = Sponsorship.second
    @sponsor = Sponsor.first
    @event = Event.first
    @region = Region.first
  end

  test 'sponsorship associations' do
    assert(@event_sponsorship.sponsor == @sponsor)
    assert(@region_sponsorship.sponsorable == @region)
    assert(@event_sponsorship.sponsorable == @event)
  end
end
