require 'test_helper'

class Admin::ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @team = Team.first
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
end
