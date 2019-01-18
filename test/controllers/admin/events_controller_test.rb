require 'test_helper'

class Admin::EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'should get index' do
    get admin_events_url
    assert_response :success
  end
end
