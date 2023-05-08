# == Schema Information
#
# Table name: team_data_sets
#
#  id                 :bigint           not null, primary key
#  team_id            :integer
#  name               :string
#  description        :text
#  description_of_use :text
#  url                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require 'test_helper'

class TeamDataSetTest < ActiveSupport::TestCase
  setup do
    @team = teams(:one)
    @team_data_set = team_data_sets(:one)
    @current_project = projects(:one)
  end

  test 'TeamDataSet Associations' do
    assert @team_data_set.team == @team
    assert @team_data_set.current_project == @current_project
  end

  test 'TeamDataSet Validations' do
    assert_not @team_data_set.update name: nil
  end
end
