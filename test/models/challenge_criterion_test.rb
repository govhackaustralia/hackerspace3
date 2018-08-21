require 'test_helper'

class ChallengeCriterionTest < ActiveSupport::TestCase
  setup do
    @challenge_criterion = ChallengeCriterion.first
    @challenge = Challenge.first
    @criterion = Criterion.first
    @challenge_judgement = ChallengeJudgement.first
  end

  test 'challenge_criterion associations' do
    assert(@challenge_criterion.challenge == @challenge)
    assert(@challenge_criterion.criterion == @criterion)
    assert(@challenge_criterion.challenge_judgements.include?(@challenge_judgement))
  end
end
