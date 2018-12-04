require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  setup do
    @entry = Entry.first
    @checkpoint = Checkpoint.first
    @challenge = Challenge.first
    @team = Team.first
    @competition = Competition.first
    @scorecard = Scorecard.first
  end

  test 'entry associations' do
    assert @entry.checkpoint == @checkpoint
    assert @entry.challenge == @challenge
    assert @entry.team == @team
    assert @entry.competition == @competition
    assert @entry.scorecards.include? @scorecard
    @entry.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @scorecard.reload }
  end

  test 'entry validations' do
    # Justification cannot be nil
    assert_not @entry.update(justification: nil)
    # No duplicate entries by Team into Challenge.
    assert_not Entry.second.update(challenge: @challenge)
  end
end
