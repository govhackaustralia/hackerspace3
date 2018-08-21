class ChallengeJudgement < ApplicationRecord
  belongs_to :assignment
  belongs_to :challenge_criterion
  belongs_to :entry

  validates :score, numericality: { less_than_or_equal_to: MAX_SCORE,
                                    greater_than_or_equal_to: MIN_SCORE,
                                    only_integer: true }
end
