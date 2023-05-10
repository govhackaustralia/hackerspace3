# frozen_string_literal: true

require 'test_helper'

class Admin::Competitions::AssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @competition = competitions(:one)
    @user = users(:one)
  end

  test 'should get index' do
    get admin_competition_assignments_url @competition
    assert_response :success
  end

  test 'should get new' do
    get new_admin_competition_assignment_url @competition, title: MANAGEMENT_TEAM
    assert_response :success
    get new_admin_competition_assignment_url @competition, title: MANAGEMENT_TEAM, term: 'x'
    assert_response :success
    get new_admin_competition_assignment_url @competition, title: MANAGEMENT_TEAM, term: 'a'
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Assignment.count', 1 do
      post admin_competition_assignments_url @competition, params: {title: MANAGEMENT_TEAM, user_id: users(:two)}
    end
    assert_redirected_to admin_competition_assignments_url @competition
  end

  test 'should post create fail' do
    assert_no_difference 'Assignment.count' do
      post admin_competition_assignments_url @competition, params: {title: MANAGEMENT_TEAM, user_id: nil}
    end
    assert_response :success
  end
end
