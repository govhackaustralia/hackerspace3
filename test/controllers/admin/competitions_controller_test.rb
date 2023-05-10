# frozen_string_literal: true

require 'test_helper'

class Admin::CompetitionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @competition = competitions(:one)
    users(:one).make_site_admin @competition
  end

  test 'should get index' do
    get admin_competitions_url
    assert_response :success
  end

  test 'should get show' do
    get admin_competition_url @competition
    assert_response :success
  end

  test 'should get new' do
    get new_admin_competition_url
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Competition.count' do
      post admin_competitions_url params: { competition: {
        year: Time.current.year - 1,
        team_form_start: Time.current,
        team_form_end: Time.current,
        start_time: Time.current,
        end_time: Time.current,
        peoples_choice_start: Time.current,
        peoples_choice_end: Time.current,
        challenge_judging_start: Time.current,
        challenge_judging_end: Time.current
      } }
    end
    assert_redirected_to admin_competition_url(new_comp = Competition.last)
    assert users(:one).assignments.where(assignable: new_comp, title: ADMIN).any?
    assert Competition.last.international_region == Region.last
  end

  test 'should post create fail' do
    assert_no_difference 'Competition.count' do
      post admin_competitions_url params: { competition: { year: nil } }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_competition_url @competition
    assert_response :success
  end

  test 'should patch update success' do
    old_time = @competition.end_time
    patch admin_competition_url @competition, params: {
      competition: { end_time: Time.now + 1.week }
    }
    assert_redirected_to admin_competition_url @competition
    @competition.reload
    assert_not @competition.end_time == old_time
  end

  test 'should patch update fail' do
    old_time = @competition.end_time
    patch admin_competition_url @competition, params: {
      competition: { end_time: nil }
    }
    assert_response :success
    @competition.reload
    assert @competition.end_time == old_time
  end

  test 'should get aws credits requested' do
    get aws_credits_requested_admin_competition_url @competition
    assert_response :success
  end

  test 'should get sponsor data set report' do
    get sponsor_data_set_report_admin_competition_url @competition
    assert_response :success
  end

  test 'should get sponsor data set report as csv' do
    get sponsor_data_set_report_admin_competition_url @competition, format: :csv
    assert_response :success
  end

  test 'should get demographics report' do
    get demographics_report_admin_competition_url @competition, field: 'age'
    assert_response :success
  end

  test 'should get demographics report as csv' do
    get sponsor_data_set_report_admin_competition_url @competition, field: 'age', format: :csv
    assert_response :success
  end
end
