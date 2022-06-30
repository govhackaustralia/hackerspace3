require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @event = events(:connection)
    @registration = Registration.first
  end

  test 'should get new' do
    get new_event_registration_url @event.identifier
    assert_response :success
  end

  test 'should get show' do
    get event_registration_url @event, @registration
    assert_response :success
  end

  test 'should get edit' do
    get edit_event_registration_url @event, @registration
    assert_response :success
  end

  test 'should patch update' do
    patch event_registration_url(@event, @registration), params: {
      registration: { status: NON_ATTENDING }
    }
    assert_redirected_to event_registration_url(@event.identifier, @registration)
    @registration.reload
    assert @registration.status == NON_ATTENDING
  end

  test 'should get limit reached' do
    get limit_reached_event_registrations_url @event.identifier
    assert_response :success
  end

  test 'should get limit (not) reached' do
    Registration.destroy_all
    get limit_reached_event_registrations_url @event.identifier
    assert_redirected_to event_url @event.identifier
  end
end
