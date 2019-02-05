require 'test_helper'

class Admin::TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @team = Team.first
    @project = Project.second
  end

  test 'should get index' do
    get admin_teams_url
    assert_response :success
  end

  test 'should get show' do
    get admin_team_url @team
    assert_response :success
  end

  test 'should patch update project' do
    patch admin_team_url @team, params: { project_id: @project.id }
    assert_redirected_to admin_team_project_url @team, @project
    @team.reload
    assert @team.current_project == @project
  end

  test 'should patch update published' do
    patch admin_team_url @team, params: { published: false }
    assert_redirected_to admin_team_url @team
    @team.reload
    assert_not @team.published
  end
end
