# frozen_string_literal: true

require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
    @competition = competitions(:one)
    @team = @project.team
  end

  test 'should get index' do
    get projects_url
    assert_response :success
  end

  test 'should get index csv' do
    get projects_url format: :csv
    assert_response :success
  end

  test 'should get show' do
    get project_url @project.identifier
    assert_response :success
  end

  test 'should get show fail competition starts tomorrow' do
    @competition.update start_time: Time.now.tomorrow, end_time: Time.now.tomorrow
    get project_url @project.identifier
    assert_redirected_to projects_path
  end

  test 'should get show fail competition finished yesterday' do
    @team.update published: false
    @competition.update start_time: Time.now.yesterday, end_time: Time.now.yesterday
    get project_url @project.identifier
    assert_redirected_to projects_path
  end

  test 'should post slack_chat fail authentication' do
    sign_out users(:one)

    post slack_chat_project_url @project.identifier
    assert_redirected_to new_user_session_path
  end

  test 'should post slack_chat fail user cannot slack chat' do
    profiles(:one).update! slack_user_id: nil

    sign_in users(:one)
    post slack_chat_project_url @project.identifier
    assert_redirected_to projects_path
  end

  test 'should post slack_chat fail team cannot slack chat' do
    teams(:one).assignments.destroy_all
    teams(:one).update! slack_channel_id: nil

    sign_in users(:one)
    post slack_chat_project_url @project.identifier
    assert_redirected_to projects_path
  end

  test 'should post slack_chat success' do
    assert @team.slack_channel_id.present?

    sign_in users(:one)
    post slack_chat_project_url @project.identifier
    assert_redirected_to "slack://channel?id=#{teams(:one).slack_channel_id}&team=#{ENV.fetch('SLACK_TEAM_ID', nil)}"
  end

  test 'should post slack_chat success connect slack' do
    @team.update! slack_channel_id: nil

    slack_channel_id = 'slack channel id'
    slack_channel_name = @team.current_project.slack_channel_name

    SlackAPIWrapper.expects(:slack_conversatons_create)
      .with(slack_channel_name)
      .returns({
        'ok' => true,
        'channel' => {
          'id' => slack_channel_id,
          'name' => slack_channel_name,
        },
      })

    FinishTeamSlackChannelJob.expects(:perform_later)
      .with(@team)
      .returns(true)

    sign_in users(:one)
    post slack_chat_project_url @project.identifier
    assert_redirected_to "slack://channel?id=#{teams(:one).slack_channel_id}&team=#{ENV.fetch('SLACK_TEAM_ID', nil)}"
  end
end
