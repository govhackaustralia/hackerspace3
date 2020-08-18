require 'test_helper'

class FavouriteTest < ActiveSupport::TestCase
  setup do
    @favourite = Favourite.first
    @team = Team.first
    @holder = Holder.first
    @assignment = Assignment.find(4)
    @project = projects :one
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
