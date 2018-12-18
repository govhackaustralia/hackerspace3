require 'test_helper'

class Events::TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = Event.first
  end

  test 'should get index public user' do
    get event_teams_url(@event.identifier)
    assert_response :success
  end

  test 'should get index authenticated user' do
    sign_in users(:one)
    get event_teams_url(@event.identifier)
    assert_response :success
  end
end
