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

  test 'challenge judgement validations' do
    assert(@challenge_judgement.update(score: MAX_SCORE))
    assert(@challenge_judgement.update(score: MIN_SCORE))
    assert_not(@challenge_judgement.update(score: MAX_SCORE + 1))
    assert_not(@challenge_judgement.update(score: MIN_SCORE - 1))
  end
end
