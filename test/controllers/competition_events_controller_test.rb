# frozen_string_literal: true

require 'test_helper'

class CompetitionEventsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get competition_events_url
    assert_response :success
  end
end
