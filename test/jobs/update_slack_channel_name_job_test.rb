# frozen_string_literal: true

require 'test_helper'

class UpdateSlackChannelNameJobTest < ActiveJob::TestCase
  test 'perform cannot update channel' do
    teams(:one).update! slack_channel_id: nil

    SlackApiWrapper.expects(:slack_conversatons_rename).never

    UpdateSlackChannelNameJob.perform_now(projects(:one))
  end

  test 'peform should not update channel' do
    assert teams(:one).slack_channel_id.present?
    assert_equal projects(:one).slack_channel_name, teams(:one).slack_channel_name

    SlackApiWrapper.expects(:slack_conversatons_rename).never

    UpdateSlackChannelNameJob.perform_now(projects(:one))
  end

  test 'perform updates channel' do
    assert teams(:one).slack_channel_id.present?
    projects(:one).update! project_name: 'new project name'
    new_project_name = projects(:one).slack_channel_name
    assert_not_equal new_project_name, teams(:one).slack_channel_name

    SlackApiWrapper.expects(:slack_conversatons_rename)
      .with(
        channel_id: teams(:one).slack_channel_id,
        channel_name: new_project_name,
      ).returns({
        'ok' => true,
        'channel' => {
          'name' => new_project_name,
        },
      })

    UpdateSlackChannelNameJob.perform_now(projects(:one))
    assert_equal new_project_name, teams(:one).reload.slack_channel_name
  end

  test 'perform fails to update channel' do
    assert teams(:one).slack_channel_id.present?
    projects(:one).update! project_name: 'new project name'
    new_project_name = projects(:one).slack_channel_name
    assert_not_equal new_project_name, teams(:one).slack_channel_name

    SlackApiWrapper.expects(:slack_conversatons_rename)
      .with(
        channel_id: teams(:one).slack_channel_id,
        channel_name: new_project_name,
      ).returns({'ok' => false, 'error' => 'error message'})

    assert_raises RuntimeError do
      UpdateSlackChannelNameJob.perform_now(projects(:one))
    end
    assert_not_equal new_project_name, teams(:one).reload.slack_channel_name
  end
end
