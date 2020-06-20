require 'test_helper'

class ShowChallengesCheckerTest < ActiveSupport::TestCase
  setup do
    @checker = ShowChallengesChecker.new(competitions(:one))
  end

  test 'show?' do
    assert @checker.show?(regions(:one))
  end
end
