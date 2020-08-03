require 'test_helper'

class ResourcesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get resources_path
    assert_response :success
  end

  test 'should get data portals' do
    get data_portals_resources_path
    assert_response :success
  end

  test 'should get tech' do
    get tech_resources_path
    assert_response :success
  end
end
