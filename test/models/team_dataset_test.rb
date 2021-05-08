require 'test_helper'

class TeamDatasetTest < ActiveSupport::TestCase
  setup do
    @team_dataset = team_datasets(:one)
    @team = teams(:one)
    @dataset = datasets(:one)
  end

  test 'team data set associations' do
    assert @team_dataset.team == @team
    assert @team_dataset.dataset == @dataset
  end

  test 'team data set validations' do
    team_dataset = TeamDataset.create(team: @team, dataset: @dataset)
    assert_not team_dataset.persisted?
  end
end
