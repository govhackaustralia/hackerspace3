require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  setup do
    @comp_assignment = Assignment.first
    @competition = Competition.first
    @region_assignment = Assignment.second
    @region = Region.first
    @user = User.first
    @judge = Assignment.find 7
    @participant = Assignment.fourth
    @favourite = Favourite.first
    @team = Team.first
    @scorecard = Scorecard.second
    @registration = Registration.first
    @competition_event = Event.second
    @region_support = Assignment.find 14
    @event_host = Assignment.third
    @event_support = Assignment.find 10
    @team_leader_assignment = Assignment.find 11
    @team_invitee = Assignment.find 12
    @team_member_assignment = Assignment.find 9
    @judge = Assignment.find 7
    @contact = Assignment.find 5
    @volunteer = Assignment.find 8
  end

  test 'assignment associations' do
    # Belongs To
    assert @comp_assignment.assignable == @competition
    assert @comp_assignment.user == @user
    assert @region_assignment.assignable == @region
    assert @region_assignment.user == @user
    # Has Many
    assert @participant.favourite_teams.include? @team
    assert @participant.scorecards.include? @scorecard
    assert @participant.registrations.include? @registration
    # Dependent destroy
    @participant.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @favourite.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @scorecard.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @registration.reload }
  end

  test 'assignment scopes' do
    assert Assignment.event_assignments.include? @participant
    assert Assignment.region_supports.include? @region_support
    assert Assignment.event_hosts.include? @event_host
    assert Assignment.event_supports.include? @event_support
    assert Assignment.participants.include? @participant
    assert Assignment.team_members.include? @team_member_assignment
    assert Assignment.team_leaders.include? @team_leader_assignment
    assert Assignment.team_invitees.include? @team_invitee
    assert Assignment.team_confirmed.include? @team_member_assignment
    assert Assignment.team_confirmed.include? @team_leader_assignment
    assert Assignment.team_participants.include? @team_leader_assignment
    assert Assignment.judges.include? @judge
    assert Assignment.staff.include? @judge
    assert Assignment.staff.exclude? @team_invitee
    assert Assignment.sponsor_contacts.include? @contact
    assert Assignment.volunteers.include? @volunteer
    assert Assignment.judgeables.include? @judge
    assert Assignment.judgeables.include? @volunteer
  end

  test 'assignment validations' do
    @comp_assignment.destroy
    # No Title
    assignment = @competition.assignments.create user: @user
    assert_not assignment.persisted?
    # Non Valid Title
    assignment = @competition.assignments.create user: @user, title: 'King'
    assert_not assignment.persisted?
    # Valid Title
    @user.assignments.destroy_all
    assignment = @competition.assignments.create user: @user, title: PARTICIPANT
    assert assignment.persisted?
  end

  test 'only_one_team_leader_assignment' do
    Registration.fourth.update status: ATTENDING
    @team_member_assignment.update! title: TEAM_LEADER

    assert @team_leader_assignment.reload.title == TEAM_MEMBER
  end

  test 'team can_only_join_team_if_registered_for_a_competition_event' do
    Registration.third.destroy
    assignment = @team.assignments.create user: @user, title: TEAM_LEADER
    assert_not assignment.persisted?
    # Fix: Something wrong with this test/method, will fail when another
    # registration for @user is made as Not Attending.
    @participant.registrations.create event: @competition_event, status: ATTENDING
    assignment = @team.assignments.create user: @user, title: TEAM_LEADER
    assert assignment.persisted?
  end
end
