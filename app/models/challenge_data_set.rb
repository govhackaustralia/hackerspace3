# frozen_string_literal: true

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
class ChallengeDataSet < ApplicationRecord
  belongs_to :challenge
  belongs_to :data_set

  validates :challenge_id, uniqueness: {
    scope: :data_set_id,
    message: 'Challenge Data Set already exists',
  }
end
