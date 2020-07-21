require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profile = profiles(:one)
  end

  test 'should get index' do
    get profiles_path
    assert_response :success
  end

  test 'sholud get show' do
    get profile_path @profile
    assert_response :success
  end
end
