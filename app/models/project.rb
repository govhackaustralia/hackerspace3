class Project < ApplicationRecord
  belongs_to :team

  validates :team_name, presence: true
end
