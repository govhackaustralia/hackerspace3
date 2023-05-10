# frozen_string_literal: true

# == Schema Information
#
# Table name: region_limits
#
#  id                      :bigint           not null, primary key
#  max_national_challenges :integer
#  max_regional_challenges :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  checkpoint_id           :integer
#  region_id               :integer
#
# Indexes
#
#  index_region_limits_on_checkpoint_id  (checkpoint_id)
#  index_region_limits_on_region_id      (region_id)
#
class RegionLimit < ApplicationRecord
  belongs_to :region
  belongs_to :checkpoint

  validates :region_id, uniqueness: {
    scope: :checkpoint_id,
    message: 'Custom Limit for this Region already exists for this Checkpoint'
  }
end
