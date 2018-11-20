require 'test_helper'

class EntriesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get stats_url
    assert_response :success
  end
end
