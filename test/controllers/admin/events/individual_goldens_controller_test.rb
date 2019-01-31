require 'test_helper'

class Admin::Events::IndividualGoldensControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @event = Event.first
    @user = User.first
    Registration.destroy_all
  end

  test 'should get new' do
    get new_admin_event_individual_golden_url @event
    assert_response :success
    get new_admin_event_individual_golden_url @event, term: 'x'
    assert_response :success
    get new_admin_event_individual_golden_url @event, term: 'open'
    assert_response :success
    get new_admin_event_individual_golden_url @event, term: @user.id
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Registration.count' do
      post admin_event_individual_goldens_url @event, params: { user_id: @user.id }
    end
    assert_redirected_to admin_event_registrations_url @event
  end

  test 'should post create fail' do
    assert_no_difference 'Registration.count' do
      post admin_event_individual_goldens_url @event, params: { user_id: nil }
    end
    assert_response :success
  end
end
