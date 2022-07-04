require 'test_helper'

class EntriesHelperTest < ActionView::TestCase
  setup do
    @region = regions(:regional)
    @competition = competitions(:one)
  end

  test 'challenges_event_counts' do
    assert challenges_event_counts(@region).instance_of?(Hash)
  end

  test 'challenges_region_counts' do
    assert challenges_region_counts(@competition).instance_of?(Hash)
  end
end
