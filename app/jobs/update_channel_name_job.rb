class UpdateChannelNameJob < ApplicationJob
  queue_as :default

  def perform(*projects)
    projects.flatten.each { |project| rename_slack_channel project }
  end

  private

  def rename_slack_channel(project)
    team = project.team
    return unless can_update_channel?(team)

    return unless should_update_channel?(project, team)

    response = SlackApiWrapper.slack_conversatons_rename(
      channel_id: team.slack_channel_id,
      channel_name: project.slack_channel_name
    )
    raise response['error'] unless response['ok']
    update_team_channel_name(team, response)
  end

  def update_team_channel_name(team, response)
    new_channel_name = response.dig('channel', 'name')
    team.update! slack_channel_name: new_channel_name
  end

  def can_update_channel?(team)
    team.present? && team.slack_channel_id.present?
  end

  def should_update_channel?(project, team)
    project.slack_channel_name != team.slack_channel_name
  end
end
