require 'test_helper'

class ChallengesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get challenges_url
    assert_response :success
  end

  test 'should get show' do
    challenge = challenges(:one)
    get challenge_url(challenge.identifier)
    assert_response :success
  end
end
