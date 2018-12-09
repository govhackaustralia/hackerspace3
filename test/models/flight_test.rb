require 'test_helper'

class FlightTest < ActiveSupport::TestCase
  setup do
    @flight = Flight.first
    @event = Event.first
    @registration_flight = RegistrationFlight.first
  end

  test 'flight associations' do
    assert @flight.event == @event
    assert @flight.registration_flights.include? @registration_flight
  end

  test 'flight validations' do
    assert_not @flight.update direction: 'Test'
  end
end
