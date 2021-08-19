class FinishTeamSlackChannelJob < ApplicationJob
  queue_as :default

  def perform(*teams)
    teams.flatten.each { |team| finish_channel_creation team }
  end

  private

  def finish_channel_creation(team)
    add_team_slack_users(team)
    add_channel_topic(team)
  end

  def add_team_slack_users(team)
    slack_user_ids = team.confirmed_slack_profiles.pluck(:slack_user_id).join(',')
    response = SlackApiWrapper.slack_conversations_invite(
      channel_id: team.slack_channel_id,
      slack_user_ids: slack_user_ids
    )
    raise response['error'] unless response['ok']
  end

  def add_channel_topic(team)
    response = SlackApiWrapper.slack_conversatons_set_topic(
      channel_id: team.slack_channel_id
    )
    raise response['error'] unless response['ok']
  end
end
