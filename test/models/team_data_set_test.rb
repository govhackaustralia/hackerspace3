require 'test_helper'

class TeamDataSetTest < ActiveSupport::TestCase
  setup do
    @team = Team.first
    @team_data_set = TeamDataSet.first
  end

  test 'TeamDataSet Associations' do
    assert(@team_data_set.team == @team)
  end
end
