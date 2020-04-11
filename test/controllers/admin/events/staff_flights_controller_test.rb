require 'test_helper'

class Admin::Events::StaffFlightsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @event = Event.first
    @staff_assignment = Assignment.second
    @holder = Holder.first
    Registration.destroy_all
  end

  test 'should get new' do
    get new_admin_event_staff_flight_url @event
    assert_response :success
    get new_admin_event_staff_flight_url @event, term: 'x'
    assert_response :success
    get new_admin_event_staff_flight_url @event, term: 'open'
    assert_response :success
    get new_admin_event_staff_flight_url @event, term: @staff_assignment.id
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Registration.count' do
      post admin_event_staff_flights_url @event, params: { registration: {
        assignment_id: @staff_assignment.id,
        holder_id: @holder.id
      } }
    end
    assert_redirected_to admin_event_registrations_url @event
  end

  test 'should post create fail' do
    assert_no_difference 'Registration.count' do
      post admin_event_staff_flights_url @event, params: { registration: { assignment_id: nil } }
    end
    assert_response :success
  end
end
