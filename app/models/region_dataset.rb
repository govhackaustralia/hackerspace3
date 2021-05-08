class RegionDataset < ApplicationRecord
  belongs_to :dataset
  belongs_to :region
  has_one :competition, through: :region

  validates :region_id, uniqueness: {
    scope: :dataset_id,
    message: 'Region Dataset already exists'
  }
end
