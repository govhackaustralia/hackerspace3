module SlackApiWrapper

  MAX_CHANNEL_LENGTH = 80

  # Channel names may only contain
  #   lowercase letters,
  #   numbers,
  #   hyphens,
  #   underscores,
  #   and must be 80 characters or less.
  def self.slack_conversatons_create(channel_name)
    response = Excon.post('https://slack.com/api/conversations.create',
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      body: URI.encode_www_form(
        token: ENV['SLACK_BOT_TOKEN'],
        name: channel_name[...MAX_CHANNEL_LENGTH]
      )
    )
    JSON.parse response.body
  end

  def self.slack_conversations_invite(channel_id:, slack_user_ids:)
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

  def self.slack_conversatons_rename(channel_id:, channel_name:)
    response = Excon.post('https://slack.com/api/conversations.rename',
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      body: URI.encode_www_form(
       token: ENV['SLACK_BOT_TOKEN'],
       channel: channel_id,
       name: channel_name[...MAX_CHANNEL_LENGTH]
      )
    )
    JSON.parse response.body
  end
end
