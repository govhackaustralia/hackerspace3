require 'test_helper'

class Admin::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test 'should patch update fail authenticate' do
    profiles(:one).update! published: true
    patch admin_profile_path(profiles(:one)), params: {
      profile: {
        published: false
      }
    }
    assert profiles(:one).reload.published
    assert_redirected_to new_user_session_path
  end

  test 'should patch update fail authorize' do
    sign_in users(:two)
    profiles(:one).update! published: true
    patch admin_profile_path(profiles(:one)), params: {
      profile: {
        published: false
      }
    }
    assert profiles(:one).reload.published
    assert_redirected_to root_path
  end

  test 'should patch update profile' do
    sign_in users(:one)
    profiles(:one).update! published: true
    patch admin_profile_path(profiles(:one)), params: {
      profile: {
        published: false
      }
    }
    assert_not profiles(:one).reload.published
    assert_redirected_to admin_user_path(users(:one))
  end
end
