# frozen_string_literal: true

require 'test_helper'

class Admin::Regions::ChallengesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @region = regions(:national)
    @challenge = challenges(:one)
  end

  test 'should get index' do
    get admin_region_challenges_url @region
    assert_response :success
  end

  test 'should get show' do
    get admin_region_challenge_url @region, @challenge
    assert_response :success
  end

  test 'should get new' do
    get new_admin_region_challenge_url @region, @challenge
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Challenge.count' do
      post admin_region_challenges_url @region, params: {challenge: {name: 'Test'}}
    end
    assert_redirected_to admin_region_challenge_url @region, Challenge.last
  end

  test 'should post create fail' do
    assert_no_difference 'Challenge.count' do
      post admin_region_challenges_url @region, params: {challenge: {name: nil}}
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_region_challenge_url @region, @challenge
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_region_challenge_url @region, @challenge, params: {challenge: {name: 'Updated'}}
    assert_redirected_to admin_region_challenge_url @region, @challenge
    @challenge.reload
    assert @challenge.name == 'Updated'
  end

  test 'should patch update fail' do
    patch admin_region_challenge_url @region, @challenge, params: {challenge: {name: nil}}
    assert_response :success
    @challenge.reload
    assert_not @challenge.name == 'Updated'
  end

  test 'should get preview' do
    @region.competition.update start_time: Time.now.tomorrow
    get preview_admin_region_challenge_path @region, @challenge
    assert_response :success
  end

  test 'should get edit banner image' do
    get edit_banner_image_admin_region_challenge_path @region, @challenge
    assert_response :success
  end

  test 'should patch update banner image' do
    picture_path = Rails.root.join('public', 'apple-touch-icon.png')
    picture = fixture_file_upload(picture_path, 'image/png')
    assert_difference -> { ActiveStorage::Attachment.count }, 1 do
      patch update_banner_image_admin_region_challenge_path(@region, @challenge), params: {
        challenge: {banner_image: picture}
      }
    end
    assert_response :success
  end
end
