# frozen_string_literal: true

require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @user = users(:one)
    @user.update(full_name: '', region: nil)
  end

  test 'should get edit' do
    get complete_registration_path
    assert_response :success
  end

  test 'should patch update success' do
    patch account_path(@user), params: { user: {
      full_name: 'Full Name',
      region: 'South Australia'
    }}
    assert_redirected_to demographics_path
    @user.reload
    assert @user.full_name = 'Full Name'
    assert @user.region = 'South Australia'
  end

  test 'should patch update fail' do
    patch account_path(@user), params: { user: {
      full_name: ''
    }}
    assert_redirected_to complete_registration_path
    @user.reload
    assert @user.full_name.empty?
  end
end
