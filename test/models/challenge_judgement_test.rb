require 'test_helper'

class ChallengeJudgementTest < ActiveSupport::TestCase
  setup do
    @challenge_judgement = ChallengeJudgement.first
    @challenge_criterion = ChallengeCriterion.first
    @challenge_scorecard = ChallengeScorecard.first
  end

  test 'challenge judgement associations' do
    assert(@challenge_judgement.challenge_scorecard == @challenge_scorecard)
    assert(@challenge_judgement.challenge_criterion == @challenge_criterion)
  end
end
