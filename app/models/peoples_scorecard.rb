class PeoplesScorecard < ApplicationRecord
  belongs_to :assignment
  belongs_to :team

  has_many :peoples_judgements

  def update_judgements
    peoples_criteria_ids = assignment.assignable.peoples_criteria.pluck(:id)
    score_card_criteria_ids = peoples_judgements.pluck(:criterion_id)
    (peoples_criteria_ids - score_card_criteria_ids).each do |criterion_id|
      peoples_judgements.create(criterion_id: criterion_id)
    end
    peoples_judgements
  end

  def total_score
    score = 0
    peoples_judgements.each do |judgement|
      return nil if judgement.score.nil?
      score += judgement.score
    end
    score
  end

  def display_score
    return 'Incomplete Card' if (score = total_score).nil?
    score
  end
end
