require 'test_helper'

class EntriesHelperTest < ActionView::TestCase
  setup do
    @region = Region.second
    @competition = Competition.first
  end

  test 'challenges_event_counts' do
    assert challenges_event_counts(@region).class == Hash
  end

  test 'challenges_region_counts' do
    assert challenges_region_counts(@competition).class == Hash
  end
end
