# frozen_string_literal: true

require 'test_helper'

class Admin::RegionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @competition = competitions(:one)
    @region = regions(:national)
  end

  test 'should get index' do
    get admin_competition_regions_url @competition
    assert_response :success
  end

  test 'should get show' do
    get admin_competition_region_url @competition, @region
    assert_response :success
  end

  test 'should get new' do
    get new_admin_competition_region_url @competition
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Region.count' do
      post admin_competition_regions_url @competition, params: {region: {
        name: 'Test Region',
        award_release: Time.now,
        time_zone: 'Sydney',
        competition: @competition,
        category: Region::REGIONAL,
        parent_id: regions(:national).id,
      }}
    end
    assert_redirected_to admin_competition_region_url @competition, Region.last
  end

  test 'should post create fail' do
    assert_no_difference 'Region.count' do
      post admin_competition_regions_url @competition, params: {region: {
        name: 'Test Region', award_release: Time.now, time_zone: 'Test',
      }}
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_competition_region_url @competition, @region
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_competition_region_url @competition, @region, params: {
      region: {name: 'Updated'},
    }
    @region.reload
    assert_redirected_to admin_competition_region_url @competition, @region
    assert @region.name == 'Updated'
  end

  test 'should patch update fail' do
    patch admin_competition_region_url @competition, @region, params: {
      region: {time_zone: 'Updated'},
    }
    assert_response :success
    @region.reload
    assert_not @region.time_zone == 'Updated'
  end
end
