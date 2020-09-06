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

  test 'should patch act_on_behalf_of_user' do
    @user.update! acting_on_behalf_of_user: nil
    patch act_on_behalf_of_user_admin_user_path @unconfirmed_user
    assert_redirected_to admin_user_path @unconfirmed_user
    @user.reload
    assert @user.acting_on_behalf_of_user == @unconfirmed_user
  end

  test 'should patch cease_acting_on_behalf_of_user' do
    acting_on_behalf_of_user = users :three
    patch cease_acting_on_behalf_of_user_admin_user_path acting_on_behalf_of_user
    assert_redirected_to admin_user_path acting_on_behalf_of_user
    @user.reload
    assert @user.acting_on_behalf_of_user.nil?
  end
end
