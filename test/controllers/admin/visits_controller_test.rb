require 'test_helper'

class Admin::VisitsControllerTest < ActionDispatch::IntegrationTest
  test 'should authenticate user' do
    get admin_competition_visits_path competitions(:one)
    assert_redirected_to new_user_session_path
  end

  test 'should authorise user' do
    sign_in users(:two)
    get admin_competition_visits_path competitions(:one)
    assert_redirected_to root_path
  end

  test 'should get index' do
    sign_in users(:one)
    get admin_competition_visits_path competitions(:one)
    assert_response :success
  end
end
