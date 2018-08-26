require 'test_helper'

class FavouriteTest < ActiveSupport::TestCase
  setup do
    @favourite = Favourite.first
    @team = Team.first
    @assignment = Assignment.find(6)
  end

  test 'favourite associations' do
    assert(@favourite.team == @team)
    assert(@favourite.assignment == @assignment)
  end
end
