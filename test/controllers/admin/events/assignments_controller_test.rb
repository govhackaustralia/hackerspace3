require 'test_helper'

class Admin::Events::AssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @event = events(:connection)
    @user = users(:one)
  end

  test 'should get index' do
    get admin_event_assignments_url @event
    assert_response :success
  end

  test 'should get new' do
    get new_admin_event_assignment_url @event, title: EVENT_HOST
    assert_response :success
    get new_admin_event_assignment_url @event, title: EVENT_HOST, term: 'x'
    assert_response :success
    get new_admin_event_assignment_url @event, title: EVENT_HOST, term: 'a'
    assert_response :success
  end

  test 'should post create success' do
    assignments(:event_host).destroy!
    assert_difference 'Assignment.count', 1 do
      post admin_event_assignments_url @event, params: { title: EVENT_HOST, user_id: @user }
    end
    assert_redirected_to admin_event_assignments_url @event
  end

  test 'should post create fail' do
    assert_no_difference 'Assignment.count' do
      post admin_event_assignments_url @event, params: { title: EVENT_HOST, user_id: nil }
    end
    assert_response :success
  end
end
