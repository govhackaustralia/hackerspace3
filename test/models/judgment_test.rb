require 'test_helper'

class JudgmentTest < ActiveSupport::TestCase
  setup do
    @judgment = Judgment.first
    @scorecard = Scorecard.first
    @criterion = Criterion.first
  end

  test 'judgment associations' do
    assert @judgment.scorecard == @scorecard
    assert @judgment.criterion == @criterion
  end
end
