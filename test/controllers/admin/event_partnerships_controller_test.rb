require 'test_helper'

class Admin::EventPartnershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @event = Event.first
    @event_partnership = EventPartnership.first
    @sponsor = Sponsor.first
  end

  test 'should get new' do
    get new_admin_event_event_partnership_url @event
    assert_response :success
  end

  test 'should post create' do
    assert_difference 'EventPartnership.count' do
      post admin_event_event_partnerships_url @event, params: { event_partnership: { sponsor_id: 1 } }
    end
    assert_redirected_to admin_region_event_url @event.region_id, @event
  end

  test 'should delete destroy' do
    assert_difference 'EventPartnership.count', -1 do
      delete admin_event_event_partnership_url @event, @event_partnership
    end
    assert_redirected_to admin_competition_sponsor_url @sponsor.competition_id, @sponsor
  end
end
