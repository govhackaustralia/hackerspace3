require 'test_helper'

class TeamManagement::TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @team = Team.first
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
end
