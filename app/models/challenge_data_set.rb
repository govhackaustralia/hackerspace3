class ChallengeDataSet < ApplicationRecord
  belongs_to :challenge
  belongs_to :data_set

  validates :challenge_id, uniqueness: { scope: :data_set_id,
                                         message: 'Challenge Data Set already exists' }
end
