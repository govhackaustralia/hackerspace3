require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.first
    sign_in users(:one)
  end

  test 'should get show' do
    get manage_account_url
    assert_response :success
  end

  test 'should get edit' do
    get update_personal_details_path
    assert_response :success
  end

  test 'should patch update' do
    patch user_path(@user), params: { user: { full_name: 'updated' } }
    assert_redirected_to manage_account_url
    @user.reload
    assert @user.full_name == 'updated'
  end
end
