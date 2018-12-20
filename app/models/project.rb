class Project < ApplicationRecord
  belongs_to :team
  belongs_to :user

  has_one :event, through: :team

  validates :team_name, :project_name, presence: true

  after_save :update_entries_eligible, :update_identifier

  after_create :update_team_current_project

  # Updates each of the entries that a team has entered and determines if the
  # team is eligible or ineligible.
  def update_entries_eligible
    team.entries.each { |entry| entry.update_eligible(self) }
  end

  # Updates the Project Identifier and checks for uniqueness.
  # ENHANCEMENT: Should be moved to Team object.
  def update_identifier
    new_identifier = uri_pritty(project_name)
    new_identifier = uri_pritty("#{project_name}-#{team.id}") if already_there?(new_identifier)
    update_columns(identifier: new_identifier)
  end

  private

  # Make the latest proect created the current project.
  def update_team_current_project
    team.update(current_project: self)
  end

  # Checks to see if an identifier has been taken.
  # ENHANCEMENT: Move to active record validations.
  def already_there?(new_identifier)
    project = Project.find_by(identifier: new_identifier)
    return false if project.nil?
    return false if project == self

    true
  end

  # Remove non URI complient strings.
  # ENHANCEMENT: Search for standard library.
  def uri_pritty(string)
    array = string.split(/\W/)
    words = array - ['']
    new_name = words.join('_')
    CGI.escape(new_name.downcase)
  end
end
