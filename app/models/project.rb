class Project < ApplicationRecord
  belongs_to :team
  belongs_to :user

  has_one :event, through: :team
  has_one :competition, through: :event

  scope :search, ->(term) { where 'team_name ILIKE ? OR project_name ILIKE ?', "%#{term}%", "%#{term}%" }

  validates :team_name, :project_name, presence: true

  after_save_commit :update_entries_eligible, :update_identifier, :update_slack_channel_name

  after_create_commit :update_team_current_project

  acts_as_ordered_taggable

  # Updates each of the entries that a team has entered and determines if the
  # team is eligible or ineligible.
  def update_entries_eligible
    team.entries.each { |entry| entry.update_eligible self }
  end

  def slack_channel_name
    "project-#{identifier}"[...SlackApiWrapper::MAX_CHANNEL_LENGTH]
  end

  private

  # Make the latest project created the current project.
  def update_team_current_project
    team.update current_project: self
  end

  def update_slack_channel_name
    return unless team.slack_channel_id.present?

    UpdateChannelNameJob.perform_later self
  end

  # Generates a unique name and updates the identifier field.
  # This is done through the project model so that old identifiers will still
  # work when a team project changes its name.
  def update_identifier
    new_identifier = uri_pritty project_name if available? new_identifier
    new_identifier ||= uri_pritty "#{project_name}-#{team.id}"
    update_columns identifier: new_identifier
  end

  # Checks to see if an identifier has been taken.
  def available?(new_identifier)
    Project.where.not(team_id: team_id).where(identifier: new_identifier).none?
  end
end
