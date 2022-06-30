require 'test_helper'

class ChallengeDataSetTest < ActiveSupport::TestCase
  setup do
    @challenge_data_set = ChallengeDataSet.first
    @challenge = challenges(:one)
    @data_set = DataSet.first
  end

  test 'challenge data set associations' do
    assert @challenge_data_set.challenge == @challenge
    assert @challenge_data_set.data_set == @data_set
  end

  test 'challenge data set validations' do
    challenge_data_set = ChallengeDataSet.create(challenge: @challenge, data_set: @data_set)
    assert_not challenge_data_set.persisted?
  end
end
