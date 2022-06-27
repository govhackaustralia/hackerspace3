require 'test_helper'

class Users::InvitationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:three)
    @invitation = assignments(:other_participant)
  end

  test 'should patch update' do
    patch users_invitation_path @invitation
    assert_redirected_to team_management_team_url @invitation.assignable
    @invitation.reload
    assert_equal TEAM_MEMBER, @invitation.title
  end

  test 'should delete destroy' do
    assert_difference 'Assignment.count', -1 do
      delete users_invitation_path @invitation
    end
    assert_redirected_to manage_account_path
  end
end
