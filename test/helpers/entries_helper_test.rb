require 'test_helper'

class EntriesHelperTest < ActionView::TestCase
  setup do
    @region = Region.second
  end

  test 'challenges_event_counts' do
    assert challenges_event_counts(@region).class == Hash
  end

  test 'challenges_region_counts' do
    assert challenges_region_counts.class == Hash
  end
end
