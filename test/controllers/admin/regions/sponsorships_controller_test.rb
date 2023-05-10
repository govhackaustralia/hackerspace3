# frozen_string_literal: true

require 'test_helper'

class Admin::Regions::SponsorshipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @region = regions(:national)
  end

  test 'should get index' do
    get admin_region_sponsorships_url @region
    assert_response :success
  end

  test 'should get new' do
    get new_admin_region_sponsorship_url @region
    assert_response :success
  end

  test 'should get new search' do
    get new_admin_region_sponsorship_url @region, term: 'h'
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Sponsorship.count' do
      post admin_region_sponsorships_url @region, params: {
        sponsorship: {
          sponsorship_type_id: sponsorship_types(:one).id,
          sponsor_id: sponsors(:one).id
        }
      }
    end
    assert_redirected_to admin_region_sponsorships_url @region
  end

  test 'should post create fail' do
    assert_no_difference 'Sponsorship.count' do
      post admin_region_sponsorships_url @region, params: {
        sponsorship: {
          sponsorship_type_id: sponsorship_types(:one).id
        }
      }
    end
    assert_response :success
  end
end
