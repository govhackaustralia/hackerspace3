require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  setup do
    @registration = Registration.first
    @assignment = Assignment.find(4)
    @user = User.first
    @event = Event.first
    @registration_flight = RegistrationFlight.first
    @flight = Flight.first
    @waitlister = User.second
    @wait_ass = Assignment.find(6)
    @inbound_flight = Flight.first
    @outbound_flight = Flight.second
  end

  test 'registration associations' do
    assert @registration.assignment == @assignment
    assert @registration.user == @user
    assert @registration.event == @event
    assert @registration.registration_flights.include? @registration_flight
    assert @registration.flights.include? @flight
    assert @registration.inbound_flight == @inbound_flight
    assert @registration.outbound_flight == @outbound_flight
    @registration.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @registration_flight.reload }
  end

  test 'registration validations' do
    @registration.destroy
    # Must have status
    new_registration = @event.registrations.create(assignment: @assignment, status: nil)
    assert_not(new_registration.persisted?)
    # non valid status
    new_registration = @event.registrations.create(assignment: @assignment, status: 'Maybe')
    assert_not(new_registration.persisted?)
    # valid status
    new_registration = @event.registrations.create(assignment: @assignment, status: VALID_ATTENDANCE_STATUSES.first)
    assert(new_registration.persisted?)
    @assignment.destroy
    assert_not @registration.persisted?
  end

  # Below test 'works' but throws an error message because mail not going anywhere.
  # test 'check for newly freed space' do
  #   @user.registrations.where(event: @event).each { |reg| reg.update(status: NON_ATTENDING) }
  #   assert(Registration.find_by(event: @event, assignment: @wait_ass).status == ATTENDING)
  # end
end
