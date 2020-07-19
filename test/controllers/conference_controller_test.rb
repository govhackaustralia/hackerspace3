require 'test_helper'

class ConferenceControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get conference_index_url
    assert_response :success
  end
end
