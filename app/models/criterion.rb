class Criterion < ApplicationRecord
  belongs_to :competition
  has_many :scores

  validates :name, :description, presence: true
  validates :category, inclusion: { in: JUDGEMENT_CATEGORIES }
end
