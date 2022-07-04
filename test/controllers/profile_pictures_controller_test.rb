require 'test_helper'

class ProfilePicturesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'should get edit' do
    get update_profile_picture_path
    assert_response :success
  end

  test 'sholud patch update' do
    # Test This
  end
end
