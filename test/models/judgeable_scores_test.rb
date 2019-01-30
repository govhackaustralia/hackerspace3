require 'test_helper'

class JudgeableScoresTest < ActiveSupport::TestCase
  setup do
    @participant = Assignment.fourth
    @judge = Assignment.find 7
    @teams = Team.all
  end

  test 'compile' do
    assert JudgeableScores.new(@participant, @teams).compile.class == Hash
    assert JudgeableScores.new(@judge, @teams).compile.class == Hash
  end
end
