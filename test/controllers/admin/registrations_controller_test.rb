require 'test_helper'

class Admin::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @event = Event.first
    @registration = Registration.first
    @user = User.first
  end

  test 'should get index' do
    get admin_event_registrations_url @event
    assert_response :success
  end

  test 'should get new' do
    get new_admin_event_registration_url @event
    assert_response :success
    get new_admin_event_registration_url @event, term: 'x'
    assert_response :success
    get new_admin_event_registration_url @event, term: 'open'
    assert_response :success
    get new_admin_event_registration_url @event, term: @user.email
    assert_response :success
  end

  test 'should post create success' do
    Registration.destroy_all
    assert_difference 'Registration.count' do
      post admin_event_registrations_url @event, params: {
        registration: {
          status: VALID_ATTENDANCE_STATUSES.sample,
          assignment_id: 4,
          holder_id: 1
        }
      }
    end
    assert_redirected_to admin_event_registrations_url @event
  end

  test 'should post create fail' do
    Registration.destroy_all
    assert_no_difference 'Registration.count' do
      post admin_event_registrations_url @event, params: {
        registration: {
          status: 'test',
          assignment_id: 4
        }
      }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_event_registration_url @event, @registration
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_event_registration_url @event, @registration, params: {
      registration: { status: NON_ATTENDING }
    }
    assert_redirected_to admin_event_registrations_url @event
    @registration.reload
    assert @registration.status == NON_ATTENDING
  end

  test 'should patch update fail' do
    new_status = 'test'
    patch admin_event_registration_url @event, @registration, params: {
      registration: { status: new_status }
    }
    assert_response :success
    @registration.reload
    assert_not @registration.status == new_status
  end
end
