class Project < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :team_name, presence: true

  def self.id_projects(projects)
    id_projects = {}
    projects.each { |project| id_projects[project.id] = project }
    id_projects
  end
end
