class ChallengeJudgement < ApplicationRecord
  belongs_to :challenge_scorecard
  belongs_to :challenge_criterion

  validates :challenge_scorecard_id, uniqueness: { scope: :challenge_criterion_id,
                                    message: 'Challenge Judgement already exists' }

  def display_score
    return score unless score.nil?
    '[No Score Recorded]'
  end
end
