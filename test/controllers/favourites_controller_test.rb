require 'test_helper'

class FavouritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @team = teams :one
    @favourite = favourites :one
    @project = projects :one
  end

  test 'should post create success' do
    Favourite.first.destroy
    assert_difference 'Favourite.count', 1 do
      post favourites_url, params: { favourite: {team_id: @team.id} }
    end
    assert_redirected_to project_path(@project.identifier)
  end

  test 'should post create fail' do
    assert_no_difference 'Favourite.count' do
      post favourites_url, params: { favourite: {team_id: @team.id} }
    end
    assert_redirected_to project_path(@project.identifier)
  end

  test 'should delete destroy success' do
    assert_difference 'Favourite.count', -1 do
      delete favourite_url(@favourite)
    end
    assert_redirected_to project_path(@project.identifier)
  end
end
