require 'test_helper'

class CheckpointTest < ActiveSupport::TestCase
  setup do
    @checkpoint = Checkpoint.first
    @competition = Competition.first
  end

  test 'checkpoint associations' do
    assert(@checkpoint.competition == @competition)
  end
end
