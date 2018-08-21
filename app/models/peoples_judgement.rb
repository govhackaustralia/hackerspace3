class PeoplesJudgement < ApplicationRecord
  belongs_to :criterion
  belongs_to :peoples_scorecard

  validates :score, numericality: { less_than_or_equal_to: MAX_SCORE,
                                    greater_than_or_equal_to: MIN_SCORE,
                                    only_integer: true }
end
