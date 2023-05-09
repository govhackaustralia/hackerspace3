# == Schema Information
#
# Table name: challenge_data_sets
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  challenge_id :integer
#  data_set_id  :integer
#
# Indexes
#
#  index_challenge_data_sets_on_challenge_id  (challenge_id)
#  index_challenge_data_sets_on_data_set_id   (data_set_id)
#
require 'test_helper'

class ChallengeDataSetTest < ActiveSupport::TestCase
  setup do
    @challenge_data_set = challenge_data_sets(:one)
    @challenge = challenges(:one)
    @data_set = data_sets(:one)
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
