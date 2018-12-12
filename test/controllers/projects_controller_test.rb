require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get projects_url
    assert_response :success
  end

  test 'should get show' do
    project = projects(:one)
    get project_url(project.identifier)
    assert_response :success
  end
end
