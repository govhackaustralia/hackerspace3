class UpdateChannelNameJob < ApplicationJob
  queue_as :default

  def perform(*projects)
    projects.flatten.each { |project| rename_slack_channel project }
  end

  private

  def rename_slack_channel(project)
    team = project.team
    return if team.nil? || team.slack_channel_id.nil?

    SlackApiWrapper.slack_conversatons_rename(
      team.slack_channel_id, project.slack_channel_name)
  end
end
