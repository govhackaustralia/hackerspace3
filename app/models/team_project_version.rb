class TeamProjectVersion < ApplicationRecord
  belongs_to :team_project

  validates :team_name, presence: true
end
