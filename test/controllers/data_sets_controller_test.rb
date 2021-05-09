require 'test_helper'

class DataSetsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get data_sets_url
    assert_response :success
  end

  test 'should get index csv' do
    get data_sets_url format: :csv
    assert_response :success
  end

  test 'should get show' do
    data_set = data_sets(:one)
    get data_set_url(data_set)
    assert_response :success
  end
end
