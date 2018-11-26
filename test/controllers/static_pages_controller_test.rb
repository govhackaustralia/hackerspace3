require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'term and conditions' do
    get terms_and_conditions_url
    assert_response :success
  end

  test 'code of conduct' do
    get code_of_conduct_url
    assert_response :success
  end
end
