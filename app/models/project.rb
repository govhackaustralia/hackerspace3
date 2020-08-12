class Project < ApplicationRecord
  belongs_to :team
  belongs_to :user

  has_one :event, through: :team
  has_one :competition, through: :event

  scope :search, ->(term) { where 'team_name ILIKE ? OR project_name ILIKE ?', "%#{term}%", "%#{term}%" }

  validates :team_name, :project_name, presence: true

  after_save_commit :update_entries_eligible, :update_identifier

  after_create_commit :update_team_current_project

  acts_as_ordered_taggable

  # Updates each of the entries that a team has entered and determines if the
  # team is eligible or ineligible.
  def update_entries_eligible
    team.entries.each { |entry| entry.update_eligible self }
  end

  private

  # Make the latest project created the current project.
  def update_team_current_project
    team.update current_project: self
  end

  # Generates a unique name and updates the identifier field.
  # ENHANCEMENT: Should be moved to Team object.
  def update_identifier
    new_identifier = uri_pritty project_name
    new_identifier = uri_pritty "#{project_name}-#{team.id}" if already_there? Project, new_identifier, self
    update_columns identifier: new_identifier
  end
end
