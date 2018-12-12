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

  test 'judgment validation' do
    assert_not @judgment.update criterion_id: 2
  end
end
