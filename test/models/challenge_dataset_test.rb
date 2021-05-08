require 'test_helper'

class ChallengeDatasetTest < ActiveSupport::TestCase
  setup do
    @challenge_dataset = challenge_datasets(:one)
    @challenge = challenges(:one)
    @dataset = datasets(:one)
  end

  test 'challenge data set associations' do
    assert @challenge_dataset.challenge == @challenge
    assert @challenge_dataset.dataset == @dataset
  end

  test 'challenge data set validations' do
    challenge_dataset = ChallengeDataset.create(challenge: @challenge, dataset: @dataset)
    assert_not challenge_dataset.persisted?
  end
end
