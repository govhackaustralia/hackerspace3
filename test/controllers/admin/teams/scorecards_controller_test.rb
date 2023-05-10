# frozen_string_literal: true

require 'test_helper'

class Admin::Teams::ScorecardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @team = teams(:one)
    @header = headers(:one)
  end

  test 'should get index' do
    get admin_team_scorecards_url @team
    assert_response :success
  end

  test 'should patch update' do
    patch admin_team_scorecard_url @team, @header, popup: true, include_judges: true
    assert_redirected_to admin_team_scorecards_url @team, popup: true, include_judges: true
    @header.reload
    assert_not @header.included
  end

  test 'should delete destroy' do
    assert_difference 'Header.count', -1 do
      delete admin_team_scorecard_url @team, @header, popup: true, include_judges: true
    end
    assert_redirected_to admin_team_scorecards_url @team, popup: true, include_judges: true
  end
end
