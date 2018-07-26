require 'test_helper'

class SponsorshipTypeTest < ActiveSupport::TestCase
  setup do
    @sponsorship_type = SponsorshipType.first
    @competition = Competition.first
    @sponsorship = Sponsorship.first
  end

  test 'sponsor associations' do
    assert(@sponsorship_type.competition == @competition)
    assert(@sponsorship_type.sponsorships.include?(@sponsorship))
  end
end
