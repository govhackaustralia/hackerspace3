require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  setup do
    @assignment = Assignment.find(1)
    @competition = Competition.find(1)
    @user = User.find(1)
  end

  test 'assignment associations' do
    assert(@assignment.assignable == @competition)
    assert(@assignment.user == @user)
  end

  test 'assignment validations' do
    @assignment.destroy
    # No Title
    assignment = @competition.assignments.create(user: @user)
    assert_not(assignment.persisted?)
    # Non Valid Title
    assignment = @competition.assignments.create(user: @user, title: 'King')
    assert_not(assignment.persisted?)
  end
end
