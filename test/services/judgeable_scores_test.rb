require 'test_helper'

class JudgeableScoresTest < ActiveSupport::TestCase
  setup do
    @participant = assignments(:participant)
    @judge = assignments(:judge)
    @teams = teams(:one, :two, :unpublished_team)
  end

  test 'compile' do
    assert JudgeableScores.new(@participant, @teams).compile.instance_of?(Hash)
    assert JudgeableScores.new(@judge, @teams).compile.instance_of?(Hash)
  end
end
