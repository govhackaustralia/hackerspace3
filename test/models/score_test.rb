require 'test_helper'

class ScoreTest < ActiveSupport::TestCase
  setup do
    @score = Score.first
    @header= Header.first
    @criterion = Criterion.first
  end

  test 'score associations' do
    assert @score.header == @header
    assert @score.criterion == @criterion
  end

  test 'score validation' do
    assert_not @score.update criterion_id: 2
  end
end
