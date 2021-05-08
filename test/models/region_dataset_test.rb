require 'test_helper'

class RegionDatasetTest < ActiveSupport::TestCase
  setup do
    @region_dataset = region_datasets(:one)
    @dataset = datasets(:one)
    @region = regions(:national)
    @competition = competitions(:one)
  end

  test 'region dataset associations' do
    assert @region_dataset.dataset == @dataset
    assert @region_dataset.region == @region
    assert @region_dataset.competition == @competition
  end
end
