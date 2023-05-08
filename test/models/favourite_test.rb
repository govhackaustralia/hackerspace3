# == Schema Information
#
# Table name: favourites
#
#  id            :bigint           not null, primary key
#  assignment_id :integer
#  team_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  holder_id     :integer
#
require 'test_helper'

class FavouriteTest < ActiveSupport::TestCase
  setup do
    @favourite = favourites(:one)
    @team = teams(:one)
    @holder = holders(:one)
    @assignment = assignments(:participant)
    @project = projects(:one)
  end

  test 'associations' do
    assert @favourite.team == @team
    assert @favourite.holder == @holder
    assert @favourite.assignment == @assignment
    assert @favourite.project == @project
  end

  test 'validations' do
    assert_not Favourite.create(team: @team, assignment: @assignment).persisted?
  end
end
