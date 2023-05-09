# == Schema Information
#
# Table name: registrations
#
#  id            :bigint           not null, primary key
#  status        :string
#  time_notified :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  assignment_id :integer
#  event_id      :integer
#  holder_id     :integer
#
# Indexes
#
#  index_registrations_on_assignment_id  (assignment_id)
#  index_registrations_on_event_id       (event_id)
#  index_registrations_on_holder_id      (holder_id)
#  index_registrations_on_status         (status)
#
require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  setup do
    @registration = registrations(:attending)
    @holder = holders(:one)
    @assignment = assignments(:participant)
    @competition = competitions(:one)
    @user = users(:one)
    @event = events(:connection)
    @waitlister = users(:two)
    @wait_ass = assignments(:vip)
    @waitlist_registration = registrations(:wait_list)
    @competition_event_registration = registrations(:attending_two)
    @non_attending_registration = registrations(:non_attending)
    @invited = registrations(:invited)
    @vip_registration = @non_attending_registration
    @award_registration = registrations(:attending_three)
  end

  test 'registration associations' do
    assert @registration.holder == @holder
    assert @registration.assignment == @assignment
    assert @registration.competition == @competition
    assert @registration.user == @user
    assert @registration.event == @event
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
    assert Registration.conference_events.include? registrations :conference_registration
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
      holder: @holder,
      status: 'Maybe'
    ).persisted?
    # Valid status
    assert @event.registrations.create(
      assignment: @assignment,
      holder: @holder,
      status: VALID_ATTENDANCE_STATUSES.sample
    ).persisted?
    @assignment.destroy
    # Dependant destroy
    assert Registration.count.zero?
  end

  test 'validate single competition event registration' do
    exception = assert_raises(ActiveRecord::RecordInvalid) do
      events(:other_competition).registrations.create!(
        assignment: @assignment,
        holder: @holder,
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
      'needs to leave teams or decline invitations before amending registration'
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

  test 'check_user_registration_type' do
    users(:one).update! registration_type: nil

    assert_raises ActiveRecord::RecordInvalid do
      events(:competition).registrations.new(
        user: users(:one),
        holder: holders(:one),
        status: ATTENDING
      ).save!
    end
  end
end
