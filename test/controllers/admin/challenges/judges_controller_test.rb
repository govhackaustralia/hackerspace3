require 'test_helper'

class Admin::Challenges::JudgesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @challenge = challenges(:one)
    @user = users(:one)
  end

  test 'should get new' do
    get new_admin_challenge_judge_path @challenge
    assert_response :success
    get new_admin_challenge_judge_path @challenge, term: 'u'
    assert_response :success
    get new_admin_challenge_judge_path @challenge, term: 'x'
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Assignment.count' do
      post admin_challenge_judges_url @challenge, params: { assignment: { user_id: @user.id } }
    end
    assert_redirected_to admin_region_challenge_url @challenge.region, @challenge
  end

  test 'should post create fail' do
    assert_no_difference 'Assignment.count' do
      post admin_challenge_judges_url @challenge, params: { assignment: { user_id: nil } }
    end
    assert_response :success
  end
end
