# == Schema Information
#
# Table name: events
#
#  id                :bigint           not null, primary key
#  accessibility     :text
#  address           :text
#  capacity          :integer
#  catering          :text
#  description       :text
#  email             :string
#  end_time          :datetime
#  event_type        :string
#  identifier        :string
#  name              :string
#  operation_hours   :text
#  parking           :text
#  public_transport  :text
#  published         :boolean          default(FALSE)
#  registration_type :string
#  start_time        :datetime
#  twitter           :string
#  youth_support     :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  place_id          :string
#  region_id         :integer
#  video_id          :string
#
# Indexes
#
#  index_events_on_identifier  (identifier)
#  index_events_on_published   (published)
#  index_events_on_region_id   (region_id)
#
require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    @event = events(:connection)
    @region = regions(:regional)
    @competition = competitions(:one)
    @event_partnership = event_partnerships(:one)
    @event_partner = sponsors(:one)
    @assignment = assignments(:event_host)
    @registration = registrations(:attending)
    @user = @registration.user
    @team = teams(:one)
    @entry = entries(:one)
    @user = users(:one)
    @vip_registration = registrations(:wait_list)
    @competition_event = events(:competition)
    @wait_ass = assignments(:vip)
    @comp_event = events(:competition)
  end

  test 'event associations' do
    assert @event.region == @region
    assert @event.competition == @competition
    assert @event.event_partnerships.include? @event_partnership
    assert @event.event_partners.include? @event_partner
    assert @event.assignments.include? @assignment
    assert @event.registrations.include? @registration
    assert @event.users.include? @user
    assert @comp_event.teams.include? @team
    assert @comp_event.entries.include? @entry
    assert @event.host_assignments.include? @assignment
    assert @event.event_hosts.include? @user
    assert @event.event_supports.include? @user
    assert @event.participant_registrations.include? @registration
    assert @event.vip_registrations.include? @vip_registration
    assert @event.attending_registrations.include? @registration
    @event.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @event_partnership.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @assignment.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @registration.reload }
  end

  test 'event scopes published' do
    assert Event.published.include? @event
    @event.update published: false
    assert Event.published.exclude? @event
  end

  test 'event scopes past future' do
    @event.update start_time: Time.now.in_time_zone(LAST_COMPETITION_TIME_ZONE) - 1.week,
                  end_time: Time.now.in_time_zone(LAST_COMPETITION_TIME_ZONE) - 1.week
    assert Event.past.include? @event
    assert Event.future.exclude? @event
    @event.update start_time: Time.now.in_time_zone(LAST_COMPETITION_TIME_ZONE) + 1.week,
                  end_time: Time.now.in_time_zone(LAST_COMPETITION_TIME_ZONE) + 1.week
    assert Event.future.include? @event
    assert Event.past.exclude? @event
  end

  test 'event scopes connections competitions awards conferences' do
    assert Event.connections.include? @event
    assert Event.competitions.include? @competition_event
    assert Event.conferences.include? events :conference
    @event.update event_type: AWARD_EVENT
    assert Event.awards.include? @event
    assert Event.locations.include? @competition_event
    @competition_event.update name: 'Remote Location'
    assert Event.remotes.include? @competition_event
    assert Event.competition(@competition).include? @event
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
    assert @event.attending? @user.event_assignment @competition
  end

  test 'check for newly freed space' do
    @wait_ass.update title: PARTICIPANT
    @event.update capacity: 2
    assert @event.registrations.attending.where(assignment: @wait_ass).present?
  end

  test 'not_remote_event?' do
    assert @event.not_remote_event?
    @event.update! name: 'Test Remote Event'
    assert_not @event.not_remote_event?
  end
end
