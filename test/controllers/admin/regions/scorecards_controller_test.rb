require 'test_helper'

class Admin::Regions::ScorecardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @region = Region.first
    @header= Header.first
  end

  test 'should get index' do
    get admin_region_scorecards_url @region
    assert_response :success
  end
end
