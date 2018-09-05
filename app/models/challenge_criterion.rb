class ChallengeCriterion < ApplicationRecord
  belongs_to :challenge
  belongs_to :criterion
  has_many :challenge_judgements, dependent: :destroy

  validates :challenge_id, uniqueness: { scope: :criterion_id,
                                         message: 'Challenge criterion already exists' }

  validates :description, presence: true
end
