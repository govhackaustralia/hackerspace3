require 'test_helper'

class PeoplesScorecardTest < ActiveSupport::TestCase
  setup do
    @peoples_scorecard = PeoplesScorecard.first
    @team = Team.first
    @assignment = Assignment.find(6)
  end

  test 'peoples scorecard associations' do
    assert(@peoples_scorecard.team == @team)
    assert(@peoples_scorecard.assignment == @assignment)
  end
end
