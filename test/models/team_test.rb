require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  setup do
    @team = teams(:one)
    @event = events(:competition)
    @project = Project.first
    @competition = competitions(:one)
    @region = regions(:regional)
    @team_member_assignment = assignments(:team_member)
    @team_member = users(:two)
    @team_leader_assignment = assignments(:team_leader)
    @team_leader = users(:one)
    @team_invitee_assignment = assignments(:invitee)
    @team_invitee = users(:three)
    @team_data_set = team_data_sets(:one)
    @favourite = Favourite.first
    @header= headers(:four)
    @entry = entries(:one)
    @challenge = challenges(:one)
    @user = users(:two)
    @regional_entry = entries(:three)
    @national_entry = @entry
  end

  test 'team associations' do
    assert @team.event == @event
    assert @team.current_project == @project

    assert @team.competition == @competition
    assert @team.region == @region

    assert @team.assignments.include? @team_member_assignment
    assert @team.users.include? @team_member

    assert @team.projects.include? @project
    assert @team.team_data_sets.include? @team_data_set
    assert @team.favourites.include? @favourite
    assert @team.headers.include? @header

    assert @team.entries.include? @entry
    assert @team.challenges.include? @challenge
    assert @team.judges.include? @user
    assert @team.judge_headers.include? @header
    assert @team.regional_entries.include? @regional_entry
    assert @team.regional_entries.exclude? @national_entry
    assert @team.national_entries.include? @national_entry
    assert @team.national_entries.exclude? @regional_entry
  end

  test 'team assignment user associations' do
    assert @team.member_assignments.include? @team_member_assignment
    assert @team.members.include? @team_member
    assert @team.leader_assignments.include? @team_leader_assignment
    assert @team.leaders.include? @team_leader
    assert @team.invitee_assignments.include? @team_invitee_assignment
    assert @team.invitees.include? @team_invitee
    assert @team.confirmed_assignments.include? @team_member_assignment
    assert @team.confirmed_assignments.include? @team_member_assignment
    assert @team.confirmed_assignments.exclude? @team_invitee_assignment
    assert @team.confirmed_members.include? @team_member
    assert @team.confirmed_members.include? @team_leader
    assert @team.confirmed_members.exclude? @team_invitee
    assert @team.confirmed_slack_profiles.include? profiles(:one)
  end

  test 'dependent destroy' do
    @team.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @team_member_assignment.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @project.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @team_data_set.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @favourite.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @header.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @entry.reload }
  end

  test 'team scopes published' do
    assert Team.published.include? @team
    assert Team.unpublished.exclude? @team
    @team.update published: false
    assert Team.published.exclude? @team
    assert Team.unpublished.include? @team
  end

  test 'team scopes competition' do
    assert Team.competition(@competition).include? @team
  end

  test 'team scopes with_assignments' do
    assert_equal 3, @team.assignments.count
    assert_equal 2, Team.with_assignments.count
    assert Team.with_assignments.include? @team
    @team.assignments.destroy_all
    assert Team.with_assignments.exclude? @team
  end

  test 'team scopes with_entries' do
    assert_equal 3, @team.entries.count
    assert_equal 1, Team.with_entries.count
    assert Team.with_entries.include? @team
    @team.entries.destroy_all
    assert Team.with_entries.exclude? @team
  end

  test 'member_competition_events' do
    assert @team.member_competition_events.include? @event
  end

  test 'search' do
    Team.search(@competition, 'A').include? @team
    Team.search(@competition, 'x').include? @team
  end

  test 'check_for_ineligible_challenge_entries' do
    exception = assert_raises(ActiveRecord::RecordInvalid) do
      @team.update! event: events(:other_competition)
    end
    assert exception.message.include?(
      'some challenge entries will not be eligible'
    )
    assert teams(:two).update event: @event
  end

  test 'assign_leader' do
    @team.assignments.destroy_all
    assert @team.assign_leader(@team_leader).persisted?
  end
end
