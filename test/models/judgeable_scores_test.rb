require 'test_helper'

class JudgeableScoresTest < ActiveSupport::TestCase
  setup do
    @participant = Assignment.fourth
    @judge = Assignment.find 7
    @teams = Team.all
  end

  test 'compile' do
    assert JudgeableScores.new(@participant, @teams).compile.instance_of?(Hash)
    assert JudgeableScores.new(@judge, @teams).compile.instance_of?(Hash)
  end
end
