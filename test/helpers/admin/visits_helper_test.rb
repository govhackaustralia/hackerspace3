require 'test_helper'

class Admin::VisitsHelperTest < ActionView::TestCase
  test 'visitable' do
    assert_equal resources(:one), visitable(visits, 'Resource', 1)
  end
end
