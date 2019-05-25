require 'test_helper'

class ScorecardTest < ActiveSupport::TestCase
  setup do
    @challenge_scorecard = @scorecard = Scorecard.first
    @peoples_scorecard = Scorecard.second
    @particpiant = Assignment.fourth
    @user = User.first
    @judgment = Judgment.first
    @entry = Entry.first
    @team = Team.first
    @team_user = User.second
  end

  test 'scorecard associations' do
    assert @challenge_scorecard.judgeable == @entry
    assert @peoples_scorecard.judgeable == @team
    assert @peoples_scorecard.assignment == @particpiant
    assert @peoples_scorecard.user == @user
    assert @scorecard.judgments.include? @judgment
    assert @scorecard.assignment_scorecards.include? @scorecard
    assert @scorecard.assignment_judgments.include? @judgment
  end

  test 'scorecard validations' do
    assert_not Scorecard.create(assignment: @particpiant, judgeable: @team).persisted?
  end

  test 'cannot_judge_your_own_team' do
    assert_not Scorecard.create(
      assignment: @team_user.event_assignment,
      judgeable: @team
    ).persisted?
  end

  test 'included scope' do
    assert Scorecard.included.include? @challenge_scorecard
    assert Scorecard.included.exclude? @peoples_scorecard
  end
end
