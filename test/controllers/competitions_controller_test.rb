# frozen_string_literal: true

require 'test_helper'

class CompetitionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get root_url
    assert_response :success
  end
end
