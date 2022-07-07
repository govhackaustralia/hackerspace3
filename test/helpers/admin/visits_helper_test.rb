require 'test_helper'

class Admin::VisitsHelperTest < ActionView::TestCase
  test 'visitable' do
    assert_equal resources(:one), visitable(visits, 'Resource', resources(:one).id)
  end

  test 'visitable_label Resource' do
    assert_equal 'Data Portal', visitable_label(resources(:one))
  end

  test 'visitable_label DataSet' do
    assert_equal 'Data Set', visitable_label(data_sets(:one))
  end
end
