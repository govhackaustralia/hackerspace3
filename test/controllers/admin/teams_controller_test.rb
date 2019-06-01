require 'test_helper'

class Admin::TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @team = Team.first
    @project = Project.second
    @competition = @team.competition
  end

  test 'should get index' do
    get admin_competition_teams_url @competition
    assert_response :success
  end

  test 'should get show' do
    get admin_competition_team_url @competition, @team
    assert_response :success
  end

  test 'should patch update project' do
    patch admin_competition_team_url @competition, @team, params: { project_id: @project.id }
    assert_redirected_to admin_team_project_url @team, @project
    @team.reload
    assert @team.current_project == @project
  end

  test 'should patch update published' do
    patch admin_competition_team_url @competition, @team, params: { published: false }
    assert_redirected_to admin_competition_team_url @competition, @team
    @team.reload
    assert_not @team.published
  end
end
