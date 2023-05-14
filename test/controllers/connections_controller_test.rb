# frozen_string_literal: true

require 'test_helper'

class ConnectionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get connections_url
    assert_response :success
  end
end
