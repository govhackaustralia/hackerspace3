# frozen_string_literal: true

require 'test_helper'

class TeamManagement::TeamDataSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @team = teams(:one)
    @team_data_set = team_data_sets(:one)
  end

  test 'should get index' do
    get team_management_team_team_data_sets_url @team
    assert_response :success
  end

  test 'should get new' do
    get new_team_management_team_team_data_set_url @team
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'TeamDataSet.count' do
      post team_management_team_team_data_sets_url @team, params: { team_data_set: {
        name: 'Test'
      } }
    end
    assert_redirected_to team_management_team_team_data_sets_url @team
  end

  test 'should post create fail' do
    assert_no_difference 'TeamDataSet.count' do
      post team_management_team_team_data_sets_url @team, params: { team_data_set: {
        name: nil
      } }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_team_management_team_team_data_set_url @team, @team_data_set
    assert_response :success
  end

  test 'should patch update success' do
    patch team_management_team_team_data_set_url @team, @team_data_set, params: { team_data_set: {
      name: 'Updated'
    } }
    assert_redirected_to team_management_team_team_data_sets_url @team
    @team_data_set.reload
    assert @team_data_set.name == 'Updated'
  end

  test 'should patch update fail' do
    patch team_management_team_team_data_set_url @team, @team_data_set, params: { team_data_set: {
      name: nil
    } }
    assert_response :success
    @team_data_set.reload
    assert_not @team_data_set.name.nil?
  end

  test 'should delete destroy' do
    assert_difference 'TeamDataSet.count', -1 do
      delete team_management_team_team_data_set_url @team, @team_data_set
    end
    assert_redirected_to team_management_team_team_data_sets_url @team
  end
end
