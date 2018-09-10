require 'test_helper'

class CriterionTest < ActiveSupport::TestCase
  setup do
    @criterion = Criterion.first
    @competition = Competition.first
    @challenge_criterion = ChallengeCriterion.first
    @entry = Entry.first
  end

  test 'criterion associations' do
    assert(@criterion.competition == @competition)
  end
end
