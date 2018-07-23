require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.find(1)
    @assignment = Assignment.find(1)
  end

  test 'user associations' do
    assert(@user.assignments.include?(@assignment))
  end

  test 'admin_privileges' do
    # Does not have.
    @assignment.destroy
    assert_not(@user.admin_privileges?)
    # Does have.
    @user.make_management_team
    assert(@user.admin_privileges?)
  end
end
