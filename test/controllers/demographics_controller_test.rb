require 'test_helper'

class DemographicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @user = users(:one)
    @profile = profiles(:one)
  end

  test 'should get edit' do
    get demographics_path
    assert_response :success
  end

  test 'should patch update success' do
    employment_status_attributes = EmploymentStatus.options.reduce({}) do |hash, attribute|
      hash.update(attribute => true)
    end
    patch demographic_path(@user), params: { profile: {
      postcode: '1111', employment_status_attributes: employment_status_attributes
    }}
    assert_redirected_to manage_account_path
    @user.reload
  end
end
