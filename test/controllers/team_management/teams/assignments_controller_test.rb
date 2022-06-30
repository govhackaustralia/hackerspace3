require 'test_helper'

class TeamManagement::Teams::AssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @team = Team.first
    @member = users(:two)
    @member_assignment = Assignment.find(9)
  end

  test 'should get index' do
    get team_management_team_assignments_url @team
    assert_response :success
  end

  test 'should get new' do
    get new_team_management_team_assignment_url @team
    assert_response :success

    get new_team_management_team_assignment_url @team, term: 'two'
    assert_response :success

    get new_team_management_team_assignment_url @team, term: '2'
    assert_response :success
  end

  test 'should post create success' do
    @member_assignment.destroy
    Registration.fourth.update status: ATTENDING
    assert_difference 'Assignment.count' do
      post team_management_team_assignments_url @team, params: { assignment: {
        user_id: @member.id
      } }
    end
    assert_redirected_to team_management_team_assignments_path @team
  end

  test 'should post create fail' do
    assert_no_difference 'Assignment.count' do
      post team_management_team_assignments_url @team, params: { assignment: {
        user_id: @member.id
      } }
    end
    assert_response :success
  end

  test 'should patch update success' do
    Registration.fourth.update status: ATTENDING
    patch team_management_team_assignment_url @team, @member_assignment
    assert_redirected_to team_management_team_assignments_url @team
    @member_assignment.reload
    assert @member_assignment.title == TEAM_LEADER
  end

  test 'should patch update fail' do
    patch team_management_team_assignment_url @team, @member_assignment
    assert_redirected_to team_management_team_assignments_url @team
    @member_assignment.reload
    assert_not @member_assignment.title == TEAM_LEADER
  end

  test 'should delete destroy' do
    assert_difference 'Assignment.count', -1 do
      delete team_management_team_assignment_url @team, @member_assignment
    end
    assert_redirected_to team_management_team_assignments_url @team
  end
end
