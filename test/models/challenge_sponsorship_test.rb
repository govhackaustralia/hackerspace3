# == Schema Information
#
# Table name: challenge_sponsorships
#
#  id           :bigint           not null, primary key
#  challenge_id :integer
#  sponsor_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  approved     :boolean          default(FALSE)
#
require 'test_helper'

class ChallengeSponsorshipTest < ActiveSupport::TestCase
  setup do
    @challenge_sponsorship = challenge_sponsorships(:one)
    @challenge = challenges(:one)
    @sponsor = sponsors(:one)
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
