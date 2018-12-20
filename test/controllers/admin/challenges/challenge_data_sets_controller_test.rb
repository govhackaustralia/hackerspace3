require 'test_helper'

class Admin::Challenges::ChallengeDataSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @challenge = Challenge.first
    @data_set = DataSet.first
    @challenge_data_set = ChallengeDataSet.first
  end

  test 'should get new' do
    get new_admin_challenge_challenge_data_set_url(@challenge)
    assert_response :success
  end

  test 'should post create' do
    ChallengeDataSet.destroy_all
    assert_difference('ChallengeDataSet.count') do
      post admin_challenge_challenge_data_sets_url(@challenge), params: { challenge_data_set: { data_set_id: @data_set.id } }
    end
    assert_redirected_to admin_region_challenge_url(@challenge.region_id, @challenge)
  end

  test 'should delete destroy' do
    assert_difference('ChallengeDataSet.count', -1) do
      delete admin_challenge_challenge_data_set_url(@challenge, @challenge_data_set)
    end
    assert_redirected_to admin_region_challenge_url(@challenge.region_id, @challenge)
  end
end
