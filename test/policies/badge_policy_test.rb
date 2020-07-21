require 'test_helper'

class ShowChallengesCheckerTest < ActiveSupport::TestCase
  setup do
    @badge = badges(:one)
  end

  test 'enough_badges?' do
    @badge.capacity = nil
    assert BadgePolicy.enough_badges? @badge
    @badge.capacity = 5
    assert BadgePolicy.enough_badges? @badge
    @badge.capacity = 1
    assert_not BadgePolicy.enough_badges? @badge
  end
end
