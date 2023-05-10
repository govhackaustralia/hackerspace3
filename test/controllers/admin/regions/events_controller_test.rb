# frozen_string_literal: true

require 'test_helper'

class Admin::Regions::EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @region = regions(:regional)
    @event = events(:connection)
  end

  test 'should get index' do
    get admin_region_events_url @region
    assert_response :success
  end

  test 'should get show' do
    get admin_region_event_url @region, @event
    assert_response :success
  end

  test 'should get preview' do
    get preview_admin_region_event_url @region, @event
    assert_response :success
  end

  test 'should get new' do
    get new_admin_region_event_url @region, @event
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Event.count' do
      post admin_region_events_url @region, params: { event: { name: 'Test', capacity: 100, registration_type: EVENT_REGISTRATION_TYPES.sample, event_type: EVENT_TYPES.sample } }
    end
    assert_redirected_to admin_region_event_url @region, Event.last
  end

  test 'should post create fail' do
    assert_no_difference 'Event.count' do
      post admin_region_events_url @region, params: { event: { name: nil } }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_region_event_url @region, @event
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_region_event_url @region, @event, params: { event: { name: 'Updated' } }
    assert_redirected_to admin_region_event_url @region, @event
    @event.reload
    assert @event.name == 'Updated'
  end

  test 'should patch update fail' do
    patch admin_region_event_url @region, @event, params: { event: { name: nil } }
    assert_response :success
    @event.reload
    assert_not @event.name == 'Updated'
  end
end
