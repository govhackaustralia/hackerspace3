# frozen_string_literal: true

require 'test_helper'

class TeamManagement::ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @team = teams(:one)
    @project = projects(:one)
    competition = @team.competition
    competition.update(
      start_time: Time.now - 1.day,
      end_time: Time.now + 1.day
    )
  end

  test 'should post create success' do
    post team_management_team_projects_url @team, params: {project: {
      team_name: 'Updated', project_name: 'Same'
    }}
    new_project = Project.last
    assert_redirected_to edit_team_management_team_project_url @team, new_project
    assert new_project.team_name == 'Updated'
  end

  test 'should get edit' do
    get edit_team_management_team_project_url @team, @project
    assert_response :success
  end

  test 'should patch update success' do
    patch team_management_team_project_url @team, @project, params: {project: {
      team_name: 'Updated', project_name: 'Same', tag_list: 'test, #Test2'
    }}
    new_project = Project.last
    assert_redirected_to edit_team_management_team_project_url @team, new_project
    assert new_project.team_name == 'Updated'
    assert new_project.project_name == 'Same'
    assert new_project.tag_list == %w[test test2]
  end

  test 'should patch update fail' do
    patch team_management_team_project_url @team, @project, params: {project: {
      team_name: nil
    }}
    assert_response :success
    @project.reload
    assert_not @project.team_name.nil?
  end
end
