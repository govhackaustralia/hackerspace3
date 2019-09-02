class RegionLimit < ApplicationRecord
  belongs_to :region
  belongs_to :checkpoint

  validates :region_id, uniqueness: {
    scope: :checkpoint_id,
    message: 'Custom Limit for this Region already exists for this Checkpoint'
  }
end
