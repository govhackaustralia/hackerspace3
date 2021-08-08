require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = Project.first
    @competition = Competition.first
    @team = @project.team
  end

  test 'should get index' do
    get projects_url
    assert_response :success
  end

  test 'should get index csv' do
    get projects_url format: :csv
    assert_response :success
  end

  test 'should get show' do
    get project_url @project.identifier
    assert_response :success
  end

  test 'should get show fail competition starts tomorrow' do
    @competition.update start_time: Time.now.tomorrow, end_time: Time.now.tomorrow
    get project_url @project.identifier
    assert_redirected_to projects_path
  end

  test 'should get show fail competition finished yesterday' do
    @team.update published: false
    @competition.update start_time: Time.now.yesterday, end_time: Time.now.yesterday
    get project_url @project.identifier
    assert_redirected_to projects_path
  end
end
