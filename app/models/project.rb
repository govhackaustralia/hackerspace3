class Project < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :team_name, :project_name, presence: true

  after_save :update_entries_eligible, :update_identifier

  def update_entries_eligible
    team.entries.each { |entry| entry.update_eligible(self) }
  end

  def self.id_projects(projects)
    id_projects = {}
    projects.each { |project| id_projects[project.id] = project }
    id_projects
  end

  def update_identifier
    new_identifier = uri_pritty(project_name)
    if already_there?(new_identifier)
      new_identifier = uri_pritty("#{project_name}-#{team.id}")
    end
    update_columns(identifier: new_identifier)
  end

  private

  def already_there?(new_identifier)
    project = Project.find_by(identifier: new_identifier)
    return false if project.nil?
    return false if project == self
    true
  end

  def uri_pritty(string)
    array = string.split(/\W/)
    words = array - ['']
    new_name = words.join('_')
    CGI.escape(new_name.downcase)
  end
end
