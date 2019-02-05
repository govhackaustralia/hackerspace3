require 'test_helper'

class Admin::Events::FlightsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @event = Event.first
    @flight = Flight.first
  end

  test 'should get index' do
    get admin_event_flights_url @event
    assert_response :success
  end

  test 'should get new' do
    get new_admin_event_flight_url @event
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Flight.count' do
      post admin_event_flights_url @event, params: { flight: { description: 'Test', direction: FLIGHT_DIRECTIONS.sample } }
    end
    assert_redirected_to admin_event_flights_url @event
  end

  test 'should post create fail' do
    assert_no_difference 'Flight.count' do
      post admin_event_flights_url @event, params: { flight: { description: 'Test', direction: nil } }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_event_flight_path @event, @flight
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_event_flight_url @event, @flight, params: { flight: { description: 'Updated' } }
    assert_redirected_to admin_event_flights_url @event
    @flight.reload
    assert @flight.description == 'Updated'
  end

  test 'should patch update fail' do
    patch admin_event_flight_url @event, @flight, params: { flight: { direction: nil } }
    assert_response :success
    @flight.reload
    assert_not @flight.description == 'Updated'
  end

  test 'should delete destroy' do
    assert_difference 'Flight.count', -1 do
      delete admin_event_flight_url @event, @flight
    end
    assert_redirected_to admin_event_flights_url @event
  end
end
