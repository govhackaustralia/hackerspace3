class TeamSlackChatService
  attr_reader :team

  def initialize(team)
    @team = team
  end

  def can_chat?
    return true if team.slack_channel_id.present?

    team.confirmed_slack_profiles.any?
  end

  def team_slack_chat_url
    raise 'team unable to chat' unless can_chat?
    connect_team_to_slack unless team.slack_channel_id.present?

    "slack://channel?id=#{team.slack_channel_id}&team=#{ENV['SLACK_TEAM_ID']}"
  end

  private

  def connect_team_to_slack
    response = SlackApiWrapper.slack_conversatons_create(
      team.current_project.slack_channel_name)
    raise response['error'] unless response['ok']
    update_team_slack_details(response)
    FinishTeamSlackChannelJob.perform_later(team)
  end

  def update_team_slack_details(response)
    slack_channel_id = response.dig('channel', 'id')
    slack_channel_name = response.dig('channel', 'name')
    team.update!(
      slack_channel_id: slack_channel_id,
      slack_channel_name: slack_channel_name
    )
  end
end
