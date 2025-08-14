# frozen_string_literal: true

require 'test_helper'

class Users::OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  GOOGLE_USER = 'test@google.com'
  CONFIRM_DATE = Time.new(2025, 1, 1)

  setup do
    OmniAuth.config.test_mode = true
  end

  test 'should confirm a new user' do
    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(
      {
        provider: 'google',
        uid: '1234567890',
        info: {
          email: GOOGLE_USER,
          name: 'Google User',
          image: 'google avatar',
        },
      },
    )

    assert_difference('User.count', 1) do
      User.find_by_email(GOOGLE_USER).tap do |user|
        assert_nil user
      end

      get '/users/auth/google/callback'

      User.find_by_email(GOOGLE_USER).tap do |user|
        assert user.confirmed?
      end
    end
  end

  test 'should confirm an existing un-confirmed user' do
    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(
      {
        provider: 'google',
        uid: '1234567890',
        info: {
          email: GOOGLE_USER,
          name: 'Google User',
          image: 'google avatar',
        },
      },
    )

    assert_difference('User.count', 1) do
      User.create!(email: GOOGLE_USER, password: Devise.friendly_token[0, 20])

      User.find_by_email(GOOGLE_USER).tap do |user|
        assert_not user.confirmed?
      end

      get '/users/auth/google/callback'

      User.find_by_email(GOOGLE_USER).tap do |user|
        assert user.confirmed?
      end
    end
  end

  test 'should not re-confirm an existing confirmed user' do
    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(
      {
        provider: 'google',
        uid: '1234567890',
        info: {
          email: GOOGLE_USER,
          name: 'Google User',
          image: 'google avatar',
        },
      },
    )

    assert_difference('User.count', 1) do
      User.create!(email: GOOGLE_USER, password: Devise.friendly_token[0, 20], confirmed_at: CONFIRM_DATE)

      User.find_by_email(GOOGLE_USER).tap do |user|
        assert user.confirmed?
      end

      get '/users/auth/google/callback'

      User.find_by_email(GOOGLE_USER).tap do |user|
        assert user.confirmed?
      end

      User.find_by_email(GOOGLE_USER).tap do |user|
        assert_equal user.confirmed_at, CONFIRM_DATE
      end
    end
  end
end
