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
require 'test_helper'

class RegionLimitTest < ActiveSupport::TestCase
  setup do
    @region = regions(:national)
    @checkpoint = checkpoints(:one)
    @region_limit = region_limits(:one)
  end

  test 'associations' do
    assert @region_limit.region == @region
    assert @region_limit.checkpoint == @checkpoint
  end

  test 'validations' do
    assert_raises(ActiveRecord::RecordInvalid) do
      RegionLimit.create! region: @region, checkpoint: @checkpoint
    end
  end
end
