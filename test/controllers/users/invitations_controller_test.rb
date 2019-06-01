require 'test_helper'

class Users::InvitationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :three
    @invitation = Assignment.find 12
  end

  test 'should patch update' do
    patch users_invitation_path @invitation
    assert_redirected_to team_management_team_url @invitation.assignable
    @invitation.reload
    assert @invitation.title == TEAM_MEMBER
  end

  test 'should delete destroy' do
    assert_difference 'Assignment.count', -1 do
      delete users_invitation_path @invitation
    end
    assert_redirected_to manage_account_path
  end
end
