require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  setup do
    @team = Team.first
    @event = Event.first
    @project = Project.first
    @competition = Competition.first
    @region = Region.second
    @team_member_assignment = Assignment.find 9
    @team_member = User.second
    @team_leader_assignment = Assignment.find 11
    @team_leader = User.first
    @team_invitee_assignment = Assignment.find 12
    @team_invitee = User.third
    @team_data_set = TeamDataSet.first
    @favourite = Favourite.first
    @scorecard = Scorecard.fourth
    @entry = Entry.first
    @challenge = Challenge.first
    @user = User.second
    @regional_entry = Entry.third
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
    assert @team.scorecards.include? @scorecard

    assert @team.entries.include? @entry
    assert @team.challenges.include? @challenge
    assert @team.judges.include? @user
    assert @team.judge_scorecards.include? @scorecard
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
  end

  test 'dependent destroy' do
    @team.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @team_member_assignment.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @project.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @team_data_set.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @favourite.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @scorecard.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @entry.reload }
  end

  test 'team scopes' do
    assert Team.published.include? @team
    @team.update published: false
    assert_not Team.published.include? @team
  end

  test 'search' do
    Team.search('A').include? @team
    Team.search('x').include? @team
  end
end
