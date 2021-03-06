require 'test_helper'

class TeamDataSetTest < ActiveSupport::TestCase
  setup do
    @team = Team.first
    @team_data_set = TeamDataSet.first
    @current_project = Project.first
  end

  test 'TeamDataSet Associations' do
    assert @team_data_set.team == @team
    assert @team_data_set.current_project == @current_project
  end

  test 'TeamDataSet Validations' do
    assert_not @team_data_set.update name: nil
  end
end
