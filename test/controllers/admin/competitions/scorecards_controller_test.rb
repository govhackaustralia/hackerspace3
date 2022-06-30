require 'test_helper'

class Admin::Competitions::ScorecardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @competition = competitions(:one)
  end

  test 'should get index' do
    get admin_competition_scorecards_url @competition
    assert_response :success
  end

  test 'should get peoples judges report csv' do
    get admin_competition_scorecards_url @competition, format: :csv
    assert_response :success
  end
end
