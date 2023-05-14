# frozen_string_literal: true

require 'test_helper'

class Users::MembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:two)
    @membership = assignments(:team_member)
  end

  test 'should delete destroy' do
    assert_difference 'Assignment.count', -1 do
      delete users_membership_path @membership
    end
    assert_redirected_to manage_account_path
  end
end
