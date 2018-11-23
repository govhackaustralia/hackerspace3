require 'test_helper'

class ChallengeSponsorshipTest < ActiveSupport::TestCase
  setup do
    @challenge_sponsorship = ChallengeSponsorship.first
    @challenge = Challenge.first
    @sponsor = Sponsor.first
  end

  test 'challenge sponsorship associations' do
    assert @challenge_sponsorship.challenge == @challenge
    assert @challenge_sponsorship.sponsor == @sponsor
  end

  test 'challenge sponsorship validations' do
    challenge_sponsorship = ChallengeSponsorship.create(sponsor: @sponsor, challenge: @challenge)
    assert_not challenge_sponsorship.persisted?
  end
end
