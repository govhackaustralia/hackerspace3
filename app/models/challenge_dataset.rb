class ChallengeDataset < ApplicationRecord
  belongs_to :dataset
  belongs_to :challenge

  validates :challenge_id, uniqueness: {
    scope: :dataset_id,
    message: 'Challenge Dataset already exists'
  }
end
