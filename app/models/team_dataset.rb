class TeamDataset < ApplicationRecord
  belongs_to :dataset
  belongs_to :team

  validates :team_id, uniqueness: {
    scope: :dataset_id,
    message: 'Team Dataset already exists'
  }
end
