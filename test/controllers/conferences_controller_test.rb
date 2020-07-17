require 'test_helper'

class ConferencesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get conferences_url
    assert_response :success
  end
end
