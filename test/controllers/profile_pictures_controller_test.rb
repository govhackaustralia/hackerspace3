# frozen_string_literal: true

require 'test_helper'

class ProfilePicturesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'should get edit' do
    get update_profile_picture_path
    assert_response :success
  end

  test 'should patch update' do
    picture_path = Rails.root.join('public', 'apple-touch-icon.png')
    picture = fixture_file_upload(picture_path, 'image/png')
    assert_difference -> { ActiveStorage::Attachment.count }, 1 do
      patch profile_picture_path(profiles(:one)), params: {
        profile: { profile_picture: picture }
      }
    end
  end
end
