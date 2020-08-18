class Favourite < ApplicationRecord
  belongs_to :team
  belongs_to :holder
  belongs_to :assignment

  has_one :project, through: :team, source: :current_project

  validates :team, uniqueness: { scope: :assignment }
end
