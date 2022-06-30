require 'test_helper'

class TeamManagement::TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @team = Team.first
    Registration.fourth.update status: ATTENDING
  end

  test 'should get show' do
    get team_management_team_url @team
    assert_response :success
  end

  test 'should get edit' do
    get edit_team_management_team_url @team
    assert_response :success
  end

  test 'should patch update success' do
    patch team_management_team_url @team, params: { team: {
      youth_team: true
    } }
    assert_redirected_to team_management_team_url @team
    @team.reload
    assert @team.youth_team
  end

  test 'should patch update fail' do
    patch team_management_team_url @team, params: { team: {
      event_id: nil
    } }
    assert_response :success
    @team.reload
    assert_not @team.event_id.nil?
  end

  test 'should get edit thumbnail' do
    get edit_thumbnail_team_management_team_url @team
    assert_response :success
  end

  test 'should patch update thumbnail' do
    patch update_thumbnail_team_management_team_url @team
    assert_redirected_to edit_thumbnail_team_management_team_url @team
  end

  test 'should get edit image' do
    get edit_image_team_management_team_url @team
    assert_response :success
  end

  test 'should patch update image' do
    patch update_image_team_management_team_url @team
    assert_redirected_to edit_image_team_management_team_url @team
  end
end
