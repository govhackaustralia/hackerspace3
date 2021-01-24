require 'test_helper'

class TeamsHelperTest < ActionView::TestCase
  setup do
    @team = teams :one
  end

  test 'team_thumbnail_asset_path return default on nothing attached' do
    assert team_thumbnail_asset_path(@team) == 'default_profile_pic.png'
  end
end
