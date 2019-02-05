require 'test_helper'

class Admin::CompetitionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @competition = Competition.first
  end

  test 'should get show' do
    get admin_competition_url(@competition)
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_competition_url(@competition)
    assert_response :success
  end

  test 'should patch update success' do
    old_time = @competition.end_time
    patch admin_competition_url(@competition), params: { competition: { end_time: Time.now + 1.week } }
    assert_redirected_to admin_competition_url(@competition)
    @competition.reload
    assert_not @competition.end_time == old_time
  end
end
