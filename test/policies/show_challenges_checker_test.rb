require 'test_helper'

class ShowChallengesCheckerTest < ActiveSupport::TestCase
  setup do
    @checker = ShowChallengesChecker.new(competitions(:one))
  end

  test 'show?' do
    assert @checker.show?(regions(:international))
    assert_not @checker.show?(regions(:other_national))
  end
end
