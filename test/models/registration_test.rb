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
    @waitlist_registration = Registration.second
    @competition_event_registration = Registration.third
    @non_attending_registration = Registration.fourth
    @vip_registration = @non_attending_registration
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

  test 'registration scopes' do
    assert Registration.attending.include? @registration
    assert Registration.waitlist.include? @waitlist_registration
    assert Registration.non_attending.include? @non_attending_registration
    assert Registration.participating.include? @registration
    assert Registration.participating.include? @waitlist_registration
    assert Registration.participating.exclude? @non_attending_registration
    assert Registration.participants.include? @registration
    assert Registration.participants.exclude? @vip_registration
    assert Registration.vips.include? @vip_registration
    assert Registration.vips.exclude? @registration
    assert Registration.competition_events.include? @competition_event_registration
    assert Registration.competition_events.exclude? @waitlist_registration
  end

  test 'registration validations' do
    @registration.destroy
    # Must have status
    assert_not @event.registrations.create(assignment: @assignment, status: nil).persisted?
    # non valid status
    assert_not @event.registrations.create(assignment: @assignment, status: 'Maybe').persisted?
    # valid status
    assert @event.registrations.create(assignment: @assignment, status: VALID_ATTENDANCE_STATUSES.sample).persisted?
    @assignment.destroy
    assert_not @registration.persisted?
  end

  # Below test 'works' but throws an error message because mail not going anywhere.
  # test 'check for newly freed space' do
  #   @user.registrations.where(event: @event).each { |reg| reg.update(status: NON_ATTENDING) }
  #   assert(Registration.find_by(event: @event, assignment: @wait_ass).status == ATTENDING)
  # end
end
