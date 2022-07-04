require 'test_helper'

class Admin::Users::AssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @vip = users(:two)
    @vip_assignment = Assignment.find 6
  end

  test 'should delete destroy' do
    assert_difference 'Assignment.count', -1 do
      delete admin_user_assignment_url @vip, @vip_assignment
    end
    assert_redirected_to admin_user_url @vip
  end
end
