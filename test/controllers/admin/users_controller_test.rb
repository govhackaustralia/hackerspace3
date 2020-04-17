require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.first
    sign_in users :one
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

  test 'should post confirm' do
    post confirm_admin_user_path @user
    assert @user.confirmed?
    assert_redirected_to admin_user_url @user
  end
end
