require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  setup do
    @comp_assignment = assignments(:management_team)
    @competition = competitions(:one)
    @region_assignment = assignments(:region_director)
    @region = regions(:national)
    @holder = Holder.first
    @user = users(:one)
    @judge = assignments(:judge)
    @participant = assignments(:participant)
    @favourite = favourites(:one)
    @team = teams(:one)
    @header= headers(:two)
    @score = scores(:three)
    @registration = registrations(:attending)
    @competition_event = events(:competition)
    @region_support = assignments(:region_support)
    @event_host = assignments(:event_host)
    @event_support = assignments(:event_support)
    @team_leader_assignment = assignments(:team_leader)
    @team_invitee = assignments(:invitee)
    @team_member_assignment = assignments(:team_member)
    @judge = assignments(:judge)
    @chief_judge = assignments(:chief_judge)
    @contact = assignments(:sponsor_contact)
    @volunteer = assignments(:volunteer)
    @participating_comp_registration = registrations(:attending_two)
  end

  test 'assignment associations' do
    # Belongs To
    assert_equal @competition, @comp_assignment.assignable
    assert_equal @holder, @comp_assignment.holder
    assert_equal @user, @comp_assignment.user
    assert_equal @region, @region_assignment.assignable
    assert_equal @user, @region_assignment.user
    # Has Many
    assert @participant.favourite_teams.include? @team
    assert @participant.headers.include? @header
    assert @participant.scores.include? @score
    assert @participant.registrations.include? @registration
    # Has One
    assert_equal profiles(:one), assignments(:management_team).profile
    # Dependent destroy
    @participant.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @favourite.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @header.reload }
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
    assert Assignment.chief_judges.include? @chief_judge
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
    assignment = @competition.assignments.create user: @user, title: PARTICIPANT, holder: @holder
    assert assignment.persisted?
  end

  test 'validation correct holder' do
    assert_raises ActiveRecord::RecordInvalid do
      assignments(:management_team).update! holder: holders(:two)
    end
  end

  test 'holder added before save' do
    assignments(:management_team).holder = nil
    assignments(:management_team).save!
    assert assignments(:management_team).present?
  end

  test 'only_one_team_leader_assignment' do
    registrations(:non_attending).update status: ATTENDING
    @team_member_assignment.update! title: TEAM_LEADER

    assert @team_leader_assignment.reload.title == TEAM_MEMBER
  end

  test 'team can_only_join_team_if_registered_for_a_competition_event' do
    @participating_comp_registration.destroy
    assignments(:team_leader).destroy
    assignment = @team.assignments.create user: @user, title: TEAM_LEADER, holder: @holder
    assert_not assignment.persisted?
    @participant.registrations.create event: @competition_event, status: ATTENDING, holder: @holder
    assignment = @team.assignments.create user: @user, title: TEAM_LEADER, holder: @holder
    assert assignment.persisted?
  end

  test 'competition_event_registration' do
    assert @participant.competition_event_registration == @participating_comp_registration
  end

  test 'cant_claim_the_same_badge_twice' do
    assert_not @user.assignments.new(
      title: ASSIGNEE,
      assignable: badges(:one),
      holder: holders(:one)
    ).save

    @user.assignments.destroy_all

    assert @user.assignments.new(
      title: ASSIGNEE,
      assignable: badges(:one),
      holder: holders(:one)
    ).save
  end

  test 'cant_exceed_badge_capacity' do
    @user.assignments.destroy_all

    assert_not @user.assignments.new(
      title: ASSIGNEE,
      assignable: badges(:two),
      holder: holders(:one)
    ).save

    assert @user.assignments.new(
      title: ASSIGNEE,
      assignable: badges(:one),
      holder: holders(:one)
    ).save
  end
end
