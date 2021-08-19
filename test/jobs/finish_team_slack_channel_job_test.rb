require 'test_helper'

class FinishTeamSlackChannelJobTest < ActiveJob::TestCase
  test 'perform finishes team slack channel creation' do
    assert teams(:one).slack_channel_id.present?

    slack_user_ids = teams(:one).confirmed_slack_profiles.pluck(:slack_user_id).join(',')

    SlackApiWrapper.expects(:slack_conversations_invite)
      .with(channel_id: teams(:one).slack_channel_id, slack_user_ids: slack_user_ids)
      .returns({'ok' => true})

    SlackApiWrapper.expects(:slack_conversatons_set_topic)
      .with(channel_id: teams(:one).slack_channel_id)
      .returns({'ok' => true})

    FinishTeamSlackChannelJob.perform_now(teams(:one))
  end

  test 'perform fails on invite users' do
    assert teams(:one).slack_channel_id.present?

    slack_user_ids = teams(:one).confirmed_slack_profiles.pluck(:slack_user_id).join(',')

    SlackApiWrapper.expects(:slack_conversations_invite)
      .with(channel_id: teams(:one).slack_channel_id, slack_user_ids: slack_user_ids)
      .returns({'ok' => false, 'error' => 'error message'})

    assert_raises RuntimeError do
      FinishTeamSlackChannelJob.perform_now(teams(:one))
    end
  end

  test 'perform fails on add channel topic' do
    assert teams(:one).slack_channel_id.present?

    slack_user_ids = teams(:one).confirmed_slack_profiles.pluck(:slack_user_id).join(',')

    SlackApiWrapper.expects(:slack_conversations_invite)
      .with(channel_id: teams(:one).slack_channel_id, slack_user_ids: slack_user_ids)
      .returns({'ok' => true})

    SlackApiWrapper.expects(:slack_conversatons_set_topic)
      .with(channel_id: teams(:one).slack_channel_id)
      .returns({'ok' => false, 'error' => 'error message'})

    assert_raises RuntimeError do
      FinishTeamSlackChannelJob.perform_now(teams(:one))
    end
  end
end
