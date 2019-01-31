require 'test_helper'

class Admin::BulkMails::UserOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @user_order = UserOrder.first
    @bulk_mail = @user_order.bulk_mail
    @mailable = @bulk_mail.mailable
  end

  test 'should patch update success' do
    patch admin_bulk_mail_user_order_url @bulk_mail, @user_order, params: { user_order: { request_type: INVITED } }
    assert_redirected_to [:admin, @mailable, @bulk_mail]
    @user_order.reload
    assert @user_order.request_type == INVITED
  end

  test 'should patch update fail' do
    patch admin_bulk_mail_user_order_url @bulk_mail, @user_order, params: { user_order: { request_type: nil } }
    assert_redirected_to [:admin, @mailable, @bulk_mail]
    @user_order.reload
    assert_not @user_order.request_type == INVITED
  end
end
