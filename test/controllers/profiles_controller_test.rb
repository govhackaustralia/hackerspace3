# frozen_string_literal: true

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
    @profile.update published: true
    get profile_path @profile
    assert_response :success
  end

  test 'should redirect on wrong profile' do
    get profile_path 'wrong identifier'
    assert_redirected_to profiles_path
  end

  test 'should not show if not published' do
    get profile_path @profile
    assert_redirected_to profiles_path
  end

  test 'should show if not published but is users' do
    sign_in users(:one)
    get profile_path @profile
    assert_response :success
  end

  test 'should not show if not published and not users' do
    sign_in users(:two)
    get profile_path @profile
    assert_redirected_to profiles_path
  end

  test 'should authorize user' do
    sign_in users(:two)
    get edit_profile_path(@profile)
    assert_redirected_to profile_path(@profile)
  end

  test 'should get edit user' do
    sign_in users(:one)
    get edit_profile_path(@profile)
    assert_response :success
  end

  test 'should patch update success' do
    sign_in users(:one)
    old_team_status = @profile.team_status
    patch profile_path @profile, params: {
      profile: {team_status: 'Team Full'},
    }
    assert_redirected_to profile_path(@profile)
    @profile.reload
    assert @profile.team_status != old_team_status
  end

  test 'should patch update fail' do
    sign_in users(:one)
    users(:one).update! accepted_code_of_conduct: nil
    patch profile_path @profile, params: {
      profile: {team_status: 'Team Full'},
    }
    assert_response :success
  end
end
