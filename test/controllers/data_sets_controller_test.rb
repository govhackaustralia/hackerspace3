require 'test_helper'

class DataSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    Competition.first.update(start_time: Time.now, end_time: Time.now)
  end

  test 'should get index' do
    get data_sets_url
    assert_response :success
  end

  test 'should get show' do
    data_set = data_sets(:one)
    get data_set_url(data_set)
    assert_response :success
  end
end
