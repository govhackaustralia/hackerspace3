require 'test_helper'

class Admin::Users::AssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @particpant = User.first
    @particpant_assignment = Assignment.fourth
    @vip = User.second
    @vip_assignment = Assignment.find 6
  end

  test 'should get edit' do
    get edit_admin_user_assignment_url @particpant, @particpant_assignment
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_user_assignment_url @particpant, @particpant_assignment, params: { assignment: {
      title: VIP
    } }
    assert_redirected_to admin_user_url @particpant
    @particpant_assignment.reload
    assert @particpant_assignment.title == VIP
  end

  test 'should patch update fail' do
    patch admin_user_assignment_url @vip, @vip_assignment, params: { assignment: {
      title: PARTICIPANT
    } }
    assert_response :success
    @vip_assignment.reload
    assert_not @vip_assignment.title == PARTICIPANT
  end

  test 'should delete destroy' do
    assert_difference 'Assignment.count', -1 do
      delete admin_user_assignment_url @vip, @vip_assignment
    end
    assert_redirected_to admin_user_url @vip
  end
end
