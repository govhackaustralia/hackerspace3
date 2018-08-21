require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  setup do
    @entry = Entry.first
    @checkpoint = Checkpoint.first
    @challenge = Challenge.first
    @team = Team.first
    @challenge_scorecard = ChallengeScorecard.first
  end

  test 'entry associations' do
    assert(@entry.checkpoint == @checkpoint)
    assert(@entry.challenge == @challenge)
    assert(@entry.team == @team)
    assert(@entry.challenge_scorecards.include?(@challenge_scorecard))
  end
end
