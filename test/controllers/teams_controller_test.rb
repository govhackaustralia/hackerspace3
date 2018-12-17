require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    Competition.current.update(start_time: Time.now.yesterday, end_time: Time.now.tomorrow)
  end

  test 'should get new' do
    get new_team_url
    assert_response :success
  end

  test 'should post create' do
    assert_difference('Team.count') do
      post teams_url params: { team: { event_id: 2, youth_team: false } }
    end
    assert_redirected_to team_management_team_path(Team.last)
  end
end
