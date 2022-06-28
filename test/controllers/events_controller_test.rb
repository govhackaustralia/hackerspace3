require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:connection)
  end

  test 'should get index' do
    get events_url
    assert_response :success
  end

  test 'should get show' do
    event = events(:connection)
    get event_url event.identifier
    assert_response :success
  end

  test 'should redirect on wrong identifier' do
    get event_url 'wrong identifier'
    assert_redirected_to events_path
  end

  test 'should redirect on not published' do
    @event.update published: nil
    get event_url @event.identifier
    assert_redirected_to root_path
  end
end
