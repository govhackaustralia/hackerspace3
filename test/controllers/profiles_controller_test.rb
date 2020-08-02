require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profile = profiles(:one)
  end

  test 'should get index' do
    get profiles_path
    assert_response :success
  end

  test 'should get show' do
    get profile_path @profile
    assert_response :success
  end

  test 'should authorize user' do
    sign_in users :two
    get edit_profile_path(@profile)
    assert_redirected_to profile_path(@profile)
  end

  test 'should get edit user' do
    sign_in users :one
    get edit_profile_path(@profile)
    assert_response :success
  end

  test 'should patch update success' do
    sign_in users :one
    old_team_status = @profile.team_status
    patch profile_path @profile, params: {
      profile: { team_status: 'Team Full' }
    }
    assert_redirected_to profile_path(@profile)
    @profile.reload
    assert @profile.team_status != old_team_status
  end
end
