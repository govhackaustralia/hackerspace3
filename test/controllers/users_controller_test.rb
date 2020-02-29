require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @user = User.first
  end

  test 'should get show' do
    get manage_account_url
    assert_response :success
  end

  test 'should get edit' do
    get update_personal_details_url
    assert_response :success
  end

  # FIX: Should be testing update, but want it broken up into smaller
  # controllers first
  test 'should patch update' do
    patch user_path(@user), params: { user: {
      full_name: 'updated',
      slack: 'updated_slack'
    } }
    assert_redirected_to manage_account_url
    @user.reload
    assert @user.full_name == 'updated'
  end

  test 'should get review_terms_and_conditions' do
    get review_terms_and_conditions_url
    assert_response :success
  end

  test 'should patch accept_terms_and_conditions success' do
    patch accept_terms_and_conditions_users_url, params: { user: {
      accepted_terms_and_conditions: true
    }}
    assert_redirected_to complete_registration_path
    @user.reload
    assert @user.accepted_terms_and_conditions
  end

  test 'should patch accept_terms_and_conditions fail' do
    @user.update! accepted_terms_and_conditions: nil
    patch accept_terms_and_conditions_users_url, params: { user: {
      accepted_terms_and_conditions: false
    }}
    assert_redirected_to review_terms_and_conditions_url
    @user.reload
    assert @user.accepted_terms_and_conditions.nil?
  end
end
