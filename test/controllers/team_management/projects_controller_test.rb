require 'test_helper'

class TeamManagement::ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @team = Team.first
    @project = Project.first
  end

  test 'should post create success' do
    post team_management_team_projects_url @team, params: { project: {
      team_name: 'Updated', project_name: 'Same'
    } }
    new_project = Project.last
    assert_redirected_to edit_team_management_team_project_url @team, new_project
    assert new_project.team_name == 'Updated'
  end

  test 'should get edit' do
    get edit_team_management_team_project_url @team, @project
    assert_response :success
  end

  test 'should patch update success' do
    patch team_management_team_project_url @team, @project, params: { project: {
      team_name: 'Updated', project_name: 'Same'
    } }
    new_project = Project.last
    assert_redirected_to edit_team_management_team_project_url @team, new_project
    assert new_project.team_name == 'Updated'
  end

  test 'should patch update fail' do
    patch team_management_team_project_url @team, @project, params: { project: {
      team_name: nil
    } }
    assert_response :success
    @project.reload
    assert_not @project.team_name.nil?
  end
end
