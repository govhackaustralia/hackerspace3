# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id              :bigint           not null, primary key
#  data_story      :text
#  description     :text
#  homepage_url    :string
#  identifier      :string
#  project_name    :string
#  source_code_url :string
#  team_name       :string
#  video_url       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  team_id         :integer
#  user_id         :integer
#
# Indexes
#
#  index_projects_on_identifier  (identifier)
#  index_projects_on_team_id     (team_id)
#  index_projects_on_user_id     (user_id)
#
class Project < ApplicationRecord
  belongs_to :team
  belongs_to :user

  has_one :event, through: :team
  has_one :competition, through: :event

  scope :search, ->(term) { where 'team_name ILIKE ? OR project_name ILIKE ?', "%#{term}%", "%#{term}%" }

  before_validation :strip_team_and_project_name

  validates :team_name, :project_name, presence: true

  after_create_commit :update_team_current_project

  after_save_commit :update_entries_eligible, :update_identifier, :update_slack_channel_name

  acts_as_ordered_taggable

  # Updates each of the entries that a team has entered and determines if the
  # team is eligible or ineligible.
  def update_entries_eligible
    team.entries.each { |entry| entry.update_eligible self }
  end

  def slack_channel_name
    "project-#{identifier}"[...SlackAPIWrapper::MAX_CHANNEL_LENGTH]
  end

  private

  def strip_team_and_project_name
    self.team_name = team_name.strip unless team_name.nil?
    self.project_name = project_name.strip unless project_name.nil?
  end

  # Make the latest project created the current project.
  def update_team_current_project
    team.update current_project: self
  end

  def update_slack_channel_name
    return unless team.slack_channel_id.present?

    UpdateSlackChannelNameJob.perform_later self
  end

  # Generates a unique name and updates the identifier field.
  # This is done through the project model so that old identifiers will still
  # work when a team project changes its name.
  def update_identifier
    new_identifier = uri_pritty project_name
    new_identifier = uri_pritty "#{project_name}-#{team.id}" unless available? new_identifier
    update_columns identifier: new_identifier
  end

  # Checks to see if an identifier has been taken.
  def available?(new_identifier)
    return false if new_identifier.blank?

    Project.where.not(team_id: team_id).where(identifier: new_identifier).none?
  end
end
