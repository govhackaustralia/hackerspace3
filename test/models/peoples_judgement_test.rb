require 'test_helper'

class PeoplesJudgementTest < ActiveSupport::TestCase
  setup do
    @peoples_judgement = PeoplesJudgement.first
    @criterion = Criterion.first
    @peoples_scorecard = PeoplesScorecard.first
  end

  test 'peoples judgement associations' do
    assert(@peoples_judgement.peoples_scorecard == @peoples_scorecard)
    assert(@peoples_judgement.criterion == @criterion)
  end

  test 'peoples judgement validations' do
    assert(@peoples_judgement.update(score: MAX_SCORE))
    assert(@peoples_judgement.update(score: MIN_SCORE))
    assert_not(@peoples_judgement.update(score: MAX_SCORE + 1))
    assert_not(@peoples_judgement.update(score: MIN_SCORE - 1))
  end
end
