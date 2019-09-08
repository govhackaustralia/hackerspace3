require 'test_helper'

class ChallengeEntryCounterTest < ActiveSupport::TestCase
  setup do
    @competition = Competition.first
    @counter = PublishedEntryCounter.new(@competition)
    @challenge = Challenge.first
  end

  test 'count' do
    assert @counter.count(@challenge).class == Integer
  end
end
