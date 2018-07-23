require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  setup do
    @comp_assignment = Assignment.find(1)
    @competition = Competition.find(1)

    @region_assignment = Assignment.find(2)
    @region = Region.find(1)

    @user = User.find(1)
  end

  test 'assignment associations' do
    assert(@comp_assignment.assignable == @competition)
    assert(@comp_assignment.user == @user)

    assert(@region_assignment.assignable == @region)
    assert(@region_assignment.user == @user)
  end

  test 'assignment validations' do
    @comp_assignment.destroy
    # No Title
    assignment = @competition.assignments.create(user: @user)
    assert_not(assignment.persisted?)
    # Non Valid Title
    assignment = @competition.assignments.create(user: @user, title: 'King')
    assert_not(assignment.persisted?)
  end
end
