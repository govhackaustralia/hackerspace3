class ChallengeJudgement < ApplicationRecord
  belongs_to :challenge_scorecard
  belongs_to :challenge_criterion

  def display_score
    return score unless score.nil?
    '[No Score Recorded]'
  end
end
