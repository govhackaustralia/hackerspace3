require 'test_helper'

class CheckpointTest < ActiveSupport::TestCase
  setup do
    @checkpoint = Checkpoint.first
    @competition = Competition.first
    @entry = Entry.first
  end

  test 'checkpoint associations' do
    assert(@checkpoint.competition == @competition)
    assert(@checkpoint.entries.include?(@entry))
  end
end
