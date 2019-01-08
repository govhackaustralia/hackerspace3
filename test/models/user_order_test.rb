require 'test_helper'

class UserOrderTest < ActiveSupport::TestCase
  setup do
    @user_order = UserOrder.first
    @bulk_mail = BulkMail.second
    @correspondence = Correspondence.second
  end

  test 'user associations' do
    assert @user_order.bulk_mail == @bulk_mail
    assert @user_order.correspondences.include? @correspondence
  end
end
