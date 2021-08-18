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
    slack_channel_id = create_team_slack_channel
    add_team_slack_users
    add_channel_topic
    slack_channel_id
  end

  def create_team_slack_channel
    response = SlackApiWrapper.slack_conversatons_create(
      team.current_project.slack_channel_name)
    raise response['error'] unless response['ok']
    update_team_slack_details(response)
  end

  def update_team_slack_details(response)
    slack_channel_id = response.dig('channel', 'id')
    slack_channel_name = response.dig('channel', 'name')
    team.update!(
      slack_channel_id: slack_channel_id,
      slack_channel_name: slack_channel_name
    )
    slack_channel_id
  end

  def add_team_slack_users
    slack_user_ids = team.confirmed_slack_profiles.pluck(:slack_user_id).join(',')
    response = SlackApiWrapper.slack_conversations_invite(
      channel_id: team.slack_channel_id,
      slack_user_ids: slack_user_ids
    )
    raise response['error'] unless response['ok']
  end

  def add_channel_topic
    response = SlackApiWrapper.slack_conversatons_set_topic(
      channel_id: team.slack_channel_id
    )
    raise response['error'] unless response['ok']
  end
end
