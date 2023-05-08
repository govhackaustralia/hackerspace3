# == Schema Information
#
# Table name: region_limits
#
#  id                      :bigint           not null, primary key
#  region_id               :integer
#  checkpoint_id           :integer
#  max_regional_challenges :integer
#  max_national_challenges :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
class RegionLimit < ApplicationRecord
  belongs_to :region
  belongs_to :checkpoint

  validates :region_id, uniqueness: {
    scope: :checkpoint_id,
    message: 'Custom Limit for this Region already exists for this Checkpoint'
  }
end
