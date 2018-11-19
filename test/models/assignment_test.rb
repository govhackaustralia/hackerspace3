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
  end

  test 'assignment associations' do
    assert @comp_assignment.assignable == @competition
    assert @comp_assignment.user == @user
    assert @region_assignment.assignable == @region
    assert @region_assignment.user == @user
    assert @participant.favourites.include? @favourite
    assert @participant.teams.include? @team
    assert @participant.scorecards.include? @scorecard
    assert @participant.registrations.include? @registration
    @participant.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @favourite.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @scorecard.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @registration.reload }
  end

  test 'assignment validations' do
    @comp_assignment.destroy
    # No Title
    assignment = @competition.assignments.create(user: @user)
    assert_not(assignment.persisted?)
    # Non Valid Title
    assignment = @competition.assignments.create(user: @user, title: 'King')
    assert_not(assignment.persisted?)
  end
end
