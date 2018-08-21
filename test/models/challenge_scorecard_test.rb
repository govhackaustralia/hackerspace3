require 'test_helper'

class ChallengeScorecardTest < ActiveSupport::TestCase
  setup do
    @challenge_scorecard = ChallengeScorecard.first
    @entry = Entry.first
    @assignment = Assignment.find(7)
  end

  test 'challenge scorecard associations' do
    assert(@challenge_scorecard.entry == @entry)
    assert(@challenge_scorecard.assignment == @assignment)
  end
end
