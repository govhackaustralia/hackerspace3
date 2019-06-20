require 'test_helper'

class CheckpointTest < ActiveSupport::TestCase
  setup do
    @checkpoint = Checkpoint.first
    @competition = Competition.first
    @entry = Entry.first
    @team = Team.first
    @root_region = Region.first
    @sub_region = Region.second
  end

  test 'checkpoint associations' do
    assert @checkpoint.competition == @competition
    assert @checkpoint.entries.include? @entry
    @checkpoint.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @entry.reload }
  end

  test 'checkpoint validations' do
    assert_not @checkpoint.update name: nil
    assert_not @checkpoint.update end_time: nil
    assert_not @checkpoint.update max_national_challenges: nil
    assert_not @checkpoint.update max_regional_challenges: nil
  end

  test 'limit reached' do
    assert @checkpoint.limit_reached? @team, @root_region
    assert_not @checkpoint.limit_reached? @team, @sub_region
  end
end
