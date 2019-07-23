require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  setup do
    @registration = Registration.first
    @assignment = Assignment.fourth
    @competition = Competition.first
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
    @invited = Registration.find 7
    @vip_registration = @non_attending_registration
    @award_registration = Registration.find(6)
  end

  test 'registration associations' do
    assert @registration.assignment == @assignment
    assert @registration.competition == @competition
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
    assert Registration.invited.include? @invited
    assert Registration.participating.include? @registration
    assert Registration.participating.include? @waitlist_registration
    assert Registration.participating.exclude? @non_attending_registration
    assert Registration.participants.include? @registration
    assert Registration.participants.exclude? @vip_registration
    assert Registration.vips.include? @vip_registration
    assert Registration.vips.exclude? @registration
    assert Registration.connection_events.include? @registration
    assert Registration.competition_events.include? @competition_event_registration
    assert Registration.award_events.include? @award_registration
    assert Registration.competition_events.exclude? @waitlist_registration
    assert Registration.competition(@competition).include? @registration
    assert Registration.aws_credits_requested.include? @waitlist_registration
  end

  # ENHANCEMENT: Break into separate test cases
  test 'registration validations' do
    Registration.destroy_all
    # Must have status
    assert_not @event.registrations.create(
      assignment: @assignment,
      status: nil
    ).persisted?
    # Non valid status
    assert_not @event.registrations.create(
      assignment: @assignment,
      status: 'Maybe'
    ).persisted?
    # Valid status
    assert @event.registrations.create(
      assignment: @assignment,
      status: VALID_ATTENDANCE_STATUSES.sample
    ).persisted?
    @assignment.destroy
    # Dependant destroy
    assert Registration.count.zero?
  end

  test 'validate single competition event registration' do
    exception = assert_raises(ActiveRecord::RecordInvalid) do
      Event.fourth.registrations.create!(
        assignment: @assignment,
        status: ATTENDING
      )
    end
    assert exception.message.include?(
      'Validation failed: User already registered for a competition event'
    )
  end

  test 'validate check_for_team_assignments' do
    exception = assert_raises(ActiveRecord::RecordInvalid) do
      @competition_event_registration.update! status: NON_ATTENDING
    end
    assert exception.message.include?(
      'leave teams or decline team invites to amend registration'
    )
  end

  test 'check for newly freed space' do
    @wait_ass.update title: PARTICIPANT
    @registration.update! status: NON_ATTENDING
    assert @event.registrations.attending.where(assignment: @wait_ass).present?
  end

  test 'if user has accepted the code of conduct' do
    @user.update! accepted_code_of_conduct: nil
    Registration.destroy_all
    assert_not @assignment.registrations.create(
      event: @event,
      status: VALID_ATTENDANCE_STATUSES.sample
    ).persisted?
  end

  # Below test 'works' but throws an error message because mail not going anywhere.
  # test 'check for newly freed space' do
  #   @user.registrations.where(event: @event).each { |reg| reg.update(status: NON_ATTENDING) }
  #   assert(Registration.find_by(event: @event, assignment: @wait_ass).status == ATTENDING)
  # end
end
