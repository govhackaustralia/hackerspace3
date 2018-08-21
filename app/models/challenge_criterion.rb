class ChallengeCriterion < ApplicationRecord
  belongs_to :challenge
  belongs_to :criterion

  validates :description, presence: true
end
