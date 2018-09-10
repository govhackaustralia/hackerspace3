require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase
  setup do
    @challenge = Challenge.first
    @competition = Competition.first
    @region = Region.first
    @sponsorship = ChallengeSponsorship.first
    @entry = Entry.first
  end

  test 'challenge associations' do
    assert(@challenge.competition == @competition)
    assert(@challenge.region == @region)
    assert(@challenge.challenge_sponsorships.include?(@sponsorship))
    assert(@challenge.entries.include?(@entry))
  end
end
