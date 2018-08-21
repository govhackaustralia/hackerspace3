class ChallengeCriterion < ApplicationRecord
  belongs_to :challenge
  belongs_to :criterion
  has_many :challenge_judgements

  validates :description, presence: true
end
