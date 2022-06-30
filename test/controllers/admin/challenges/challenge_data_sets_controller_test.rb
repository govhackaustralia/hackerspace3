require 'test_helper'

class Admin::Challenges::ChallengeDataSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @challenge = challenges(:one)
    @data_set = data_sets(:one)
    @challenge_data_set = challenge_data_sets(:one)
  end

  test 'should get new' do
    get new_admin_challenge_challenge_data_set_url @challenge
    assert_response :success
  end

  test 'should post create success' do
    ChallengeDataSet.destroy_all
    assert_difference 'ChallengeDataSet.count' do
      post admin_challenge_challenge_data_sets_url @challenge, params: {
        challenge_data_set: { data_set_id: @data_set.id }
      }
    end
    assert_redirected_to admin_region_challenge_url @challenge.region, @challenge
  end

  test 'should post create fail' do
    ChallengeDataSet.destroy_all
    assert_no_difference 'ChallengeDataSet.count' do
      post admin_challenge_challenge_data_sets_url @challenge, params: {
        challenge_data_set: { data_set_id: nil }
      }
    end
    assert_response :success
  end

  test 'should delete destroy' do
    assert_difference 'ChallengeDataSet.count', -1 do
      delete admin_challenge_challenge_data_set_url @challenge, @challenge_data_set
    end
    assert_redirected_to admin_region_challenge_url @challenge.region, @challenge
  end
end
