require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.first
    @assignment = Assignment.first
    @scorecard = Scorecard.second
  end

  test 'user_validations' do
    # no email don't save
    assert_not(User.create(email: nil).save)

    # no full name don't save
    assert_not(User.create(preferred_name: nil).save)
  end

  test 'user associations' do
    assert @user.assignments.include? @assignment
    assert @user.scorecards.include? @scorecard
    # Dependent Destroy
    id = @user.id
    @user.destroy
    assert(Assignment.where(user_id: id).empty?)
  end

  test 'admin_privileges' do
    # Does have.
    assert(@user.admin_privileges?)
    # Does not have.
    @assignment.destroy
    assert_not(@user.admin_privileges?)
  end
end
