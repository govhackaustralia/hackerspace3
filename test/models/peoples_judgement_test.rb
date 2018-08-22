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
end
