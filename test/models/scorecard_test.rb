require 'test_helper'

class ScorecardTest < ActiveSupport::TestCase
  setup do
    @challenge_scorecard = @scorecard = Scorecard.first
    @peoples_scorecard = Scorecard.second
    @judgment = Judgment.first
    @entry = Entry.first
    @team = Team.first
    @particpiant = Assignment.find(4)
  end

  test 'scorecard associations' do
    assert @scorecard.judgments.include?(@judgment)
    assert @challenge_scorecard.judgeable == @entry
    assert @peoples_scorecard.judgeable == @team
    assert @peoples_scorecard.assignment == @particpiant
  end
end
