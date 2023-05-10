# frozen_string_literal: true

require 'test_helper'

class TeamSlackChatServiceTest < ActiveSupport::TestCase
  test 'can_chat? true slack_id present' do
    assert teams(:one).slack_channel_id.present?

    assert TeamSlackChatService.new(teams(:one)).can_chat?
  end

  test 'can_chat? true confirmed slack profiles' do
    teams(:one).update! slack_channel_id: nil
    assert teams(:one).slack_channel_id.nil?
    assert teams(:one).confirmed_slack_profiles.any?

    assert TeamSlackChatService.new(teams(:one)).can_chat?
  end

  test 'can_chat? false' do
    assert teams(:two).slack_channel_id.nil?
    assert teams(:two).confirmed_slack_profiles.empty?

    assert_not TeamSlackChatService.new(teams(:two)).can_chat?
  end

  test 'team_slack_chat_url slack_channel_id present' do
    assert teams(:one).slack_channel_id.present?

    assert_equal(
      "slack://channel?id=#{teams(:one).slack_channel_id}&team=#{ENV.fetch('SLACK_TEAM_ID', nil)}",
      TeamSlackChatService.new(teams(:one)).team_slack_chat_url
    )
  end

  test 'team_slack_chat_url slack_channel_id nil' do
    teams(:one).update! slack_channel_id: nil
    slack_channel_id = 'slack channel id'
    slack_channel_name = teams(:one).current_project.slack_channel_name

    SlackApiWrapper.expects(:slack_conversatons_create)
      .with(slack_channel_name)
      .returns({
        'ok' => true,
        'channel' => {
          'id' => slack_channel_id,
          'name' => slack_channel_name
        }
      })

    FinishTeamSlackChannelJob.expects(:perform_later)
      .with(teams(:one))
      .returns(true)

    assert_equal(
      "slack://channel?id=#{slack_channel_id}&team=#{ENV.fetch('SLACK_TEAM_ID', nil)}",
      TeamSlackChatService.new(teams(:one)).team_slack_chat_url
    )

    assert_equal slack_channel_name, teams(:one).reload.slack_channel_name
  end

  test 'team_slack_chat_url slack_conversatons_create fail' do
    teams(:one).update! slack_channel_id: nil
    slack_channel_name = teams(:one).current_project.slack_channel_name

    SlackApiWrapper.expects(:slack_conversatons_create)
      .with(slack_channel_name)
      .returns({'ok' => false, 'error' => 'error message'})

    assert_raises RuntimeError do
      TeamSlackChatService.new(teams(:one)).team_slack_chat_url
    end
  end
end
