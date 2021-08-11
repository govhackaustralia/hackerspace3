require 'test_helper'

class VisitTest < ActiveSupport::TestCase
  test 'visit associations' do
    assert_equal users(:one), visits(:one).user
    assert_equal competitions(:one), visits(:one).competition
    assert_equal resources(:one), visits(:one).visitable
  end
end
