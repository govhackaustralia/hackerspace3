require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    @event = Event.first
    @region = Region.second
    @competition = Competition.first
    @event_partnership = EventPartnership.first
    @event_partner = Sponsor.first
    @assignment = Assignment.third
    @registration = Registration.first
    @team = Team.first
    @entry = Entry.first
    @user = User.first
    @flight = Flight.first
    @bulk_mail = BulkMail.second
    @vip_registration = Registration.second
    @competition_event = Event.second
  end

  test 'event associations' do
    assert @event.region == @region
    assert @event.competition == @competition
    assert @event.event_partnership == @event_partnership
    assert @event.event_partner == @event_partner
    assert @event.assignments.include? @assignment
    assert @event.registrations.include? @registration
    assert @event.teams.include? @team
    assert @event.entries.include? @entry
    assert @event.flights.include? @flight
    assert @event.bulk_mails.include? @bulk_mail
    assert @event.host_assignments.include? @assignment
    assert @event.event_hosts.include? @user
    assert @event.event_supports.include? @user
    assert @event.participant_registrations.include? @registration
    assert @event.vip_registrations.include? @vip_registration
    @event.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @event_partnership.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @assignment.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @registration.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @bulk_mail.reload }
  end

  test 'event scopes' do
    assert Event.published.include? @event
    @event.update published: false
    assert Event.published.exclude? @event
    assert Event.competitions.include? @competition_event
  end

  test 'event validations' do
    assert_not @event.update capacity: nil
    assert @event.update capacity: 10
    assert_not @event.update registration_type: 'Test'
    assert @event.update registration_type: EVENT_REGISTRATION_TYPES.sample
    assert_not @event.update event_type: 'Test'
    assert @event.update event_type: EVENT_TYPES.sample
  end

  test 'attending method' do
    assert @event.attending? @user.event_assignment
  end
end
