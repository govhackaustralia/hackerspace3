# frozen_string_literal: true

require 'test_helper'

class Admin::EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @competition = competitions(:one)
  end

  test 'should get index' do
    get admin_competition_events_url @competition
    assert_response :success
  end
end
