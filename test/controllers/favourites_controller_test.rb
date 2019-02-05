require 'test_helper'

class FavouritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @team = Team.first
  end

  test 'should post create' do
    Favourite.first.destroy
    assert_difference('Favourite.count') do
      post favourites_url, params: { team_id: @team.id }
    end
    assert_redirected_to project_path(@team.current_project.identifier)
  end

  test 'should post create fail' do
    assert_no_difference('Favourite.count') do
      post favourites_url, params: { team_id: @team.id }
    end
    assert_redirected_to project_path(@team.current_project.identifier)
  end
end
