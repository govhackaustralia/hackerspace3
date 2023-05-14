# frozen_string_literal: true

require 'test_helper'

class ChallengeEntryCounterTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:one)
    @counter = PublishedEntryCounter.new(@competition)
    @challenge = challenges(:one)
  end

  test 'count' do
    assert @counter.count(@challenge).instance_of?(Integer)
  end

  test 'count with challenge_ids' do
    counter = PublishedEntryCounter.new(@competition, challenge_ids: [challenges(:one).id])
    assert counter.count(@challenge).instance_of?(Integer)
  end
end
