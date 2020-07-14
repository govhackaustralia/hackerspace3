require 'test_helper'

class Admin::BadgesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @badge = badges :one
    @competition = competitions :one
  end

  test 'should get index' do
    get admin_competition_badges_path(@competition)
    assert_response :success
  end

  test 'should get show' do
    get admin_competition_badge_path(@competition, @badge)
    assert_response :success
  end

  test 'should get new' do
    get new_admin_competition_badge_path(@competition)
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Badge.count' do
      post admin_competition_badges_path(@competition), params: {
        badge: {
          name: 'test'
        }
      }
    end
    assert_redirected_to admin_competition_badge_path @competition, Badge.last
  end

  test 'should post create fail' do
    assert_no_difference 'Badge.count' do
      post admin_competition_badges_path(@competition), params: {
        badge: {
          name: nil
        }
      }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_competition_badge_path(@competition, @badge)
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_competition_badge_path(@competition, @badge), params: {
      badge: {
        name: 'updated',
        capacity: 4
      }
    }
    @badge.reload
    assert_redirected_to admin_competition_badge_url(@competition, @badge)
    assert @badge.name == 'updated'
  end

  test 'should patch update fail' do
    patch admin_competition_badge_path(@competition, @badge), params: {
      badge: {
        name: 'updated',
        capacity: -1
      }
    }
    @badge.reload
    assert_response :success
    assert @badge.name == 'MyString'
  end

  test 'should delete destroy' do
    assert_difference 'Badge.count', -1 do
      delete admin_competition_badge_path(@competition, @badge)
    end
    assert_redirected_to admin_competition_badges_url(@competition)
    assert_raises(ActiveRecord::RecordNotFound) { @badge.reload }
  end
end
