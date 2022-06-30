require 'test_helper'

class ChallengeEntryCounterTest < ActiveSupport::TestCase
  setup do
    @competition = Competition.first
    @counter = PublishedEntryCounter.new(@competition)
    @challenge = challenges(:one)
  end

  test 'count' do
    assert @counter.count(@challenge).instance_of?(Integer)
  end

  test 'count with challenge_ids' do
    counter = PublishedEntryCounter.new(@competition, challenge_ids: [1])
    assert counter.count(@challenge).instance_of?(Integer)
  end
end
