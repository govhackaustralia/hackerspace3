require 'test_helper'

class Admin::ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @team = teams(:one)
    @project = Project.first
  end

  test 'should get index' do
    get admin_team_projects_url @team
    assert_response :success
  end

  test 'should get show' do
    get admin_team_project_url @team, @project
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_team_project_url @team, @project
    assert_response :success
  end

  test 'should patch update' do
    patch admin_team_project_url @team, @project, params: { project: {
      team_name: 'Updated', description: 'updated', data_story: 'updated',
      source_code_url: 'updated', video_url: 'updated', homepage_url: 'updated',
      project_name: 'updated'
    } }
    new_project = Project.last
    assert_redirected_to admin_team_project_url @team, new_project
    assert new_project.team_name == 'Updated'
  end

  test 'should patch update fail' do
    patch admin_team_project_url @team, @project, params: { project: {
      team_name: nil
    } }
    assert_response :success
    @project.reload
    assert_not @project.team_name.nil?
  end
end
