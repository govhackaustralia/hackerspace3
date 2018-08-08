require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase
  setup do
    @challenge = Challenge.first
    @competition = Competition.first
    @region = Region.first
    @sponsorship = Sponsorship.third
  end

  test 'challenge associations' do
    assert(@challenge.competition == @competition)
    assert(@challenge.region == @region)
    assert(@challenge.sponsorships.include?(@sponsorship))
  end
end
