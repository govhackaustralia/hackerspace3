require 'test_helper'

class Flights::Registrations::RegistrationFlightsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @registration = Registration.first
    @flight = Flight.first
    @event = @registration.event
  end

  test 'should get new' do
    get new_flights_registration_registration_flight_url @registration
    assert_response :success
  end

  test 'should post create success' do
    RegistrationFlight.destroy_all
    assert_difference 'RegistrationFlight.count' do
      post flights_registration_registration_flights_url @registration, params: {
        registration_flight: { flight_id: @flight.id }
      }
    end
    assert_redirected_to event_registration_url @event.identifier, @registration
  end

  test 'should post create fail' do
    assert_no_difference 'RegistrationFlight.count' do
      post flights_registration_registration_flights_url @registration, params: {
        registration_flight: { flight_id: nil }
      }
    end
    assert_response :success
  end
end
