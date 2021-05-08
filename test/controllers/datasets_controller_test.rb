require 'test_helper'

class DatasetsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get datasets_url
    assert_response :success
  end

  test 'should get index csv' do
    get datasets_url format: :csv
    assert_response :success
  end

  test 'should get show' do
    get dataset_url(datasets(:one))
    assert_response :success
  end
end
