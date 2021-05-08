class RegionDataset < ApplicationRecord
  belongs_to :dataset
  belongs_to :region
  has_one :competition, through: :region
end
