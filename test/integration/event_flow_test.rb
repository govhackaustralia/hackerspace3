# frozen_string_literal: true

require 'test_helper'

class EventFlowTest < ActionDispatch::IntegrationTest
  test 'can see the welcome page' do
    get '/'
    assert_select 'h1'
  end
end
