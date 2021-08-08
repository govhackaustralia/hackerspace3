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
    slack_channel_id = team.slack_channel_id
    slack_channel_id ||= connect_team_to_slack

    "slack://channel?id=#{slack_channel_id}&team=#{ENV['SLACK_TEAM_ID']}"
  end

  private

  def connect_team_to_slack
    raise 'no connected slack profiles' unless team.confirmed_slack_profiles.any?
    slack_channel_id = create_team_slack_channel
    add_team_slack_users
    slack_channel_id
  end

  def create_team_slack_channel
    response = slack_conversatons_create
    raise response['error'] unless response['ok']
    slack_channel_id = response.dig('channel', 'id')
    team.update! slack_channel_id: slack_channel_id
    slack_channel_id
  end

  def add_team_slack_users
    slack_user_ids = team.confirmed_slack_profiles.pluck(:slack_user_id).join(',')
    response = slack_conversatons_invite(team.slack_channel_id, slack_user_ids)
    raise response['error'] unless response['ok']
  end

  # Channel names may only contain
  #   lowercase letters,
  #   numbers,
  #   hyphens,
  #   underscores,
  #   and must be 80 characters or less.
  def slack_conversatons_create
    response = Excon.post('https://slack.com/api/conversations.create',
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      body: URI.encode_www_form(
        token: ENV['SLACK_BOT_TOKEN'],
        name: team.current_project.identifier[...80]
      )
    )
    JSON.parse response.body
  end

  def slack_conversatons_invite(channel_id, slack_user_ids)
    response = Excon.post('https://slack.com/api/conversations.invite',
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      body: URI.encode_www_form(
       token: ENV['SLACK_BOT_TOKEN'],
       channel: channel_id,
       users: slack_user_ids
      )
    )
    JSON.parse response.body
  end
end
