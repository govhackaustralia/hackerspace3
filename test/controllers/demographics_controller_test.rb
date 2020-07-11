require 'test_helper'

class DemographicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @user = users(:one)
    @profile = profiles(:one)
  end

  test 'should get edit' do
    get demographics_path
    assert_response :success
  end

  test 'should patch update success' do
    patch demographic_path(@user), params: { profile: {
      postcode: '1111'
    }}
    assert_redirected_to manage_account_path
    @user.reload
  end
end
