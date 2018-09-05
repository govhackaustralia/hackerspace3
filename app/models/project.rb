class Project < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :team_name, presence: true

  after_save :update_entries_eligible

  def update_entries_eligible
    team.entries.each { |entry| entry.update_eligible(self) }
  end

  def self.id_projects(projects)
    id_projects = {}
    projects.each { |project| id_projects[project.id] = project }
    id_projects
  end
end
