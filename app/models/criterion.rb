class Criterion < ApplicationRecord
  belongs_to :competition
  has_many :challenge_criteria

  validates :name, :description, presence: true
  validates :category, inclusion: { in: JUDGEMENT_CATEGORIES }
end
