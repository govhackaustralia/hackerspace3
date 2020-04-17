require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.first
    sign_in users :one
    @unconfirmed_user = users(:unconfirmed_user)
  end

  test 'should get index' do
    get admin_users_url
    assert_response :success
  end

  test 'should get user registration report' do
    get admin_users_url format: :csv
    assert_response :success
  end

  test 'should get mailing_list_export' do
    get mailing_list_export_admin_users_url format: :csv
    assert_response :success
  end

  test 'should get show' do
    get admin_user_url @user
    assert_response :success
  end

  test 'should post confirm success' do
    post confirm_admin_user_path @unconfirmed_user
    @unconfirmed_user.reload
    assert @unconfirmed_user.confirmed?
    assert_redirected_to admin_user_url @unconfirmed_user
  end

  test 'should post confirm fail' do
    @unconfirmed_user.update! confirmation_sent_at: Time.now - 3.days
    post confirm_admin_user_path @unconfirmed_user
    assert_response :success
    @unconfirmed_user.reload
    assert_not @unconfirmed_user.confirmed?
  end
end
