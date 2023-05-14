# frozen_string_literal: true

require 'test_helper'

class ChallengesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @competition = competitions(:one)
    @challenge = challenges(:one)
  end

  test 'should get index' do
    get challenges_path
  end

  test 'should get table' do
    @competition.update(
      start_time: Time.now.yesterday,
      end_time: Time.now.yesterday
    )
    get table_challenges_url
    assert_response :success
    @competition.update(
      start_time: Time.now.tomorrow,
      end_time: Time.now.tomorrow
    )
    get table_challenges_url
    assert_redirected_to landing_page_challenges_url
  end

  test 'should get show' do
    get challenge_url @challenge.identifier
    assert_response :success
  end

  test 'should get entries' do
    get entries_challenge_url @challenge.identifier
    assert_response :success
  end

  test 'should get entries table' do
    get entries_table_challenge_url @challenge.identifier
    assert_response :success
  end
end
