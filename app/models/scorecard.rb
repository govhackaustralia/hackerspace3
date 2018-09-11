class Scorecard < ApplicationRecord
  has_many :judgments, dependent: :destroy

  belongs_to :assignment
  has_one :user, through: :assignment
  belongs_to :judgeable, polymorphic: true

  validate :only_one_scorecard_per_judgeable, :cannot_judge_your_own_team

  def update_judgments
    criteria_ids = Competition.current.criteria.where(category: type).pluck(:id)
    score_card_criteria_ids = judgments.pluck(:criterion_id)
    (criteria_ids - score_card_criteria_ids).each do |criterion_id|
      judgments.create(criterion_id: criterion_id)
    end
  end

  def type
    return CHALLENGE if judgeable_type == 'Entry'
    PROJECT
  end

  def only_one_scorecard_per_judgeable
    if Scorecard.find_by(assignment: assignment, judgeable: judgeable).present?
      errors.add(:assignment_id, 'Only one scorecard allowed per judgeable entity')
    end
  end

  def cannot_judge_your_own_team
    return if judgeable_type == 'Entry'
    if judgeable.users.include? user
      errors.add(:assignment_id, 'Participants are not permitted to vote for a team they are a member in.')
    end
  end

  def total_score
    score = 0
    judgments.each do |judgment|
      return nil if judgment.score.nil?
      score += judgment.score
    end
    score
  end

  def display_score
    score = total_score
    return 'Scorecard Incomplete' if score.nil?
    score
  end
  
  def max_score
	score = 0
	judgments.each do |judgment|
      return nil if judgment.score.nil?
      score += 10
    end
    score
  end
end
