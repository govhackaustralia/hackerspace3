require 'test_helper'

class ChallengesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Competition.first.update(start_time: Time.now - 5.days,
                             end_time: Time.now - 3.days,
                             peoples_choice_start: Time.now + 6.days,
                             peoples_choice_end: Time.now + 1.month,
                             challenge_judging_start: Time.now - 1.days,
                             challenge_judging_end: Time.now + 1.month)
  end

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
