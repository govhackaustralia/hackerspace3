require 'test_helper'

class Admin::Regions::DataSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @region = Region.first
    @data_set = data_sets(:one)
  end

  test 'should get index' do
    get admin_region_data_sets_url @region
    assert_response :success
  end

  test 'should get new' do
    get new_admin_region_data_set_url @region, @data_set
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'DataSet.count' do
      post admin_region_data_sets_url @region, params: { data_set: { name: 'Test' } }
    end
    assert_redirected_to admin_region_data_sets_url @region
  end

  test 'should post create fail' do
    assert_no_difference 'DataSet.count' do
      post admin_region_data_sets_url @region, params: { data_set: { name: nil } }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_region_data_set_url @region, @data_set
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_region_data_set_url @region, @data_set, params: { data_set: { name: 'Updated' } }
    assert_redirected_to admin_region_data_sets_url @region
    @data_set.reload
    assert @data_set.name == 'Updated'
  end

  test 'should patch update fail' do
    patch admin_region_data_set_url @region, @data_set, params: { data_set: { name: nil } }
    assert_response :success
    @data_set.reload
    assert_not @data_set.name == 'Updated'
  end
end
