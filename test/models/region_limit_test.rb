require 'test_helper'

class RegionLimitTest < ActiveSupport::TestCase
  setup do
    @region = Region.first
    @checkpoint = Checkpoint.first
    @region_limit = RegionLimit.first
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
