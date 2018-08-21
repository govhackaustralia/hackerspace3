class Criterion < ApplicationRecord
  belongs_to :competition

  validates :description, presence: true
  validates :category, inclusion: { in: JUDGEMENT_CATEGORIES }
end
