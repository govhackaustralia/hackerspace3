require 'test_helper'

class ConnectionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get events_url
    assert_response :success
  end

  test 'should get show' do
    get connection_url(Connection.first.identifier)
    assert_response :success
  end
end
