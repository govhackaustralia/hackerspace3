require 'test_helper'

class HeaderTest < ActiveSupport::TestCase
  setup do
    @challenge_header = @header= headers(:one)
    @peoples_header = headers(:two)
    @particpiant = Assignment.fourth
    @user = users(:one)
    @score = Score.first
    @entry = entries(:one)
    @team = Team.first
    @team_user = users(:two)
  end

  test 'header associations' do
    assert @challenge_header.scoreable == @entry
    assert @peoples_header.scoreable == @team
    assert @peoples_header.assignment == @particpiant
    assert @peoples_header.user == @user
    assert @header.scores.include? @score
    assert @header.assignment_headers.include? @header
    assert @header.assignment_scores.include? @score
  end

  test 'header validations' do
    assert_not Header.create(assignment: @particpiant, scoreable: @team).persisted?
  end

  test 'cannot_judge_your_own_team' do
    assert_not Header.create(
      assignment: @team_user.event_assignment(@team.competition),
      scoreable: @team
    ).persisted?
  end

  test 'included scope' do
    assert Header.included.include? @challenge_header
    assert Header.included.exclude? @peoples_header
  end
end
