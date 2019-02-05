require 'test_helper'

class Admin::ChallengeSponsorshipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @challenge = Challenge.first
    @challenge_sponsorship = ChallengeSponsorship.first
    @region = Region.first
  end

  test 'should get new' do
    get new_admin_challenge_challenge_sponsorship_url(@challenge)
    assert_response :success
  end

  test 'should post create success' do
    ChallengeSponsorship.destroy_all
    assert_difference('ChallengeSponsorship.count') do
      post admin_challenge_challenge_sponsorships_url(@challenge), params: { sponsor_id: 1 }
    end
    assert_redirected_to admin_region_challenge_url(@region, @challenge)
  end

  test 'should post create fail' do
    assert_no_difference('ChallengeSponsorship.count') do
      post admin_challenge_challenge_sponsorships_url(@challenge), params: { sponsor_id: 1 }
    end
    assert_response :success
  end

  test 'should delete destroy' do
    assert_difference('ChallengeSponsorship.count', -1) do
      delete admin_challenge_challenge_sponsorship_url(@challenge, @challenge_sponsorship)
    end
    assert_redirected_to admin_region_challenge_url(@region, @challenge)
  end
end
