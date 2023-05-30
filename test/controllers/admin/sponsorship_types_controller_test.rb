# frozen_string_literal: true

require 'test_helper'

class Admin::SponsorshipTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @sponsorship_type = sponsorship_types(:one)
    @competition = competitions(:one)
  end

  test 'should get index' do
    get admin_competition_sponsorship_types_url @competition
    assert_response :success
  end

  test 'should get new' do
    get new_admin_competition_sponsorship_type_url @competition
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'SponsorshipType.count' do
      post admin_competition_sponsorship_types_url(
        @competition, params: {
          sponsorship_type: {name: 'Example', position: 1},
        },
      )
    end
    assert_redirected_to admin_competition_sponsorship_types_url @competition
  end

  test 'should post create fail' do
    assert_no_difference 'SponsorshipType.count' do
      post admin_competition_sponsorship_types_url(
        @competition, params: {
          sponsorship_type: {name: 'Example', position: nil},
        },
      )
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_competition_sponsorship_type_url(
      @competition, @sponsorship_type,
    )
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_competition_sponsorship_type_url(
      @competition, @sponsorship_type, params: {
        sponsorship_type: {name: 'Updated'},
      },
    )
    assert_redirected_to admin_competition_sponsorship_types_url @competition
    @sponsorship_type.reload
    assert @sponsorship_type.name == 'Updated'
  end

  test 'should patch update fail' do
    patch admin_competition_sponsorship_type_url(
      @competition, @sponsorship_type, params: {
        sponsorship_type: {name: nil},
      },
    )
    assert_response :success
    @sponsorship_type.reload
    assert_not_nil @sponsorship_type.name
  end
end
