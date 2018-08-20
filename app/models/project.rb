class Project < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :team_name, presence: true
end
