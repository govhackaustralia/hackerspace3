# frozen_string_literal: true

require 'test_helper'

class RegionsControllerTest < ActionDispatch::IntegrationTest
  test 'get show success regional' do
    get region_path regions(:regional)
    assert_response :success
  end

  test 'get show success national' do
    get region_path regions(:national)
    assert_response :success
  end

  test 'get show success international' do
    get region_path regions(:international)
    assert_response :success
  end

  test 'get show fail' do
    regions(:other_national).challenges.destroy_all
    get region_path regions(:other_national)
    assert_redirected_to challenges_url
  end
end
