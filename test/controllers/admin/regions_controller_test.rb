require 'test_helper'

class Admin::RegionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @region = Region.first
  end

  test 'should get index' do
    get admin_regions_url
    assert_response :success
  end

  test 'should get show' do
    get admin_region_url @region
    assert_response :success
  end

  test 'should get new' do
    get new_admin_region_url
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Region.count' do
      post admin_regions_url params: { region: { name: 'Test Region', award_release: Time.now, time_zone: 'Sydney' } }
    end
    assert_redirected_to admin_regions_url
  end

  test 'should post create fail' do
    assert_no_difference 'Region.count' do
      post admin_regions_url params: { region: { name: 'Test Region', award_release: Time.now, time_zone: 'Test' } }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_region_url @region
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_region_url @region, params: { region: { name: 'Updated' } }
    assert_redirected_to admin_region_url @region
    @region.reload
    assert @region.name == 'Updated'
  end

  test 'should patch update fail' do
    patch admin_region_url @region, params: { region: { time_zone: 'Updated' } }
    assert_response :success
    @region.reload
    assert_not @region.time_zone == 'Updated'
  end
end
