class Favourite < ApplicationRecord
  belongs_to :team
  belongs_to :assignment

  validates :team, uniqueness: { scope: :assignment }
end
