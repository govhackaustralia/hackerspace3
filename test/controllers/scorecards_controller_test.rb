require 'test_helper'

class ScorecardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = Project.first
    @header= Header.third
    Competition.first.update(
      peoples_choice_start: Time.now.yesterday,
      peoples_choice_end: Time.now.tomorrow
    )
  end

  test 'should get new' do
    users(:one).update! acting_on_behalf_of_user: nil
    sign_in users(:one)
    get new_project_scorecard_path(@project.identifier)
    assert_response :success
  end

  test 'should get edit' do
    users(:one).update! acting_on_behalf_of_user: nil
    sign_in users(:one)
    get edit_project_scorecard_path(@project.identifier, @header)
    assert_response :success
  end

  test 'get edit authorise_edit_update! fail' do
    sign_in users(:two)
    get edit_project_scorecard_path(@project.identifier, @header)
    assert_redirected_to root_path
  end

  test 'patch update authorise_edit_update! fail' do
    sign_in users(:two)
    patch project_scorecard_path(@project.identifier, @header)
    assert_redirected_to root_path
  end
end
