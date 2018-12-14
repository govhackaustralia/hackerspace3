class TeamDataSet < ApplicationRecord
  belongs_to :team
  has_one :current_project, through: :team

  validates :name, presence: true
end
