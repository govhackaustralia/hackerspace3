require 'test_helper'

class EventFlowTest < ActionDispatch::IntegrationTest
  test "can see the welcome page" do
    get "/"
    assert_select "h2"
  end
end
