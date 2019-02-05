require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get events_url
    assert_response :success
  end

  test 'should get show' do
    event = events :one
    get event_url event.identifier
    assert_response :success
  end
end
