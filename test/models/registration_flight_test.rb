require 'test_helper'

class RegistrationFlightTest < ActiveSupport::TestCase
  setup do
    @registration_flight = RegistrationFlight.first
    @flight = Flight.first
    @registration = Registration.first
  end

  test 'registration flight associations' do
    assert @registration_flight.flight == @flight
    assert @registration_flight.registration == @registration
  end

  test 'registration flight validations' do
    assert_not @registration_flight.update flight_id: 2
  end
end
