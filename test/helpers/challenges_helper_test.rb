require 'test_helper'

class ChallengesHelperTest < ActionView::TestCase
  setup do
    @challenge = Challenge.first
    @checkpoint = Checkpoint.first
    @team = Team.first
  end

  test 'challenge_teams' do
    assert challenge_teams(@checkpoint).include? @team
  end
end
