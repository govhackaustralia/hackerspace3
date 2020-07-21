require 'test_helper'

class ClaimsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
    sign_in @user
    @badge = badges :one
  end

  test 'should get new' do
    get new_badge_claim_path(@badge)
    assert_response :success
  end

  test 'should create success' do
    assignments(:badge_assignment).destroy!
    assert_difference 'Assignment.count' do
      post badge_claims_path(@badge)
    end
    assert_redirected_to profile_path profiles(:one)
  end

  test 'should create fail' do
    @user.assignments.create(title: ASSIGNEE, holder: holders(:one), assignable: @badge)
    assert_no_difference 'Assignment.count' do
      post badge_claims_path(@badge)
    end
    assert_response :success
  end
end
