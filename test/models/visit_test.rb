require 'test_helper'

class VisitTest < ActiveSupport::TestCase
  test 'visit associations' do
    assert_equal users(:one), visits(:resource).user
    assert_equal competitions(:one), visits(:resource).competition
    assert_equal resources(:one), visits(:resource).visitable
  end
end
