class Scorecard < ApplicationRecord
  has_many :judgments, dependent: :destroy

  belongs_to :assignment
  has_one :user, through: :assignment
  belongs_to :judgeable, polymorphic: true

  validate :only_one_scorecard_per_judgeable
  
  def update_judgments
    category = if judgeable_type == 'Entry'
                CHALLENGE
              else
                PROJECT
              end
    criteria_ids = Competition.current.criteria.where(category: category).pluck(:id)
    score_card_criteria_ids = judgments.pluck(:criterion_id)
    (criteria_ids - score_card_criteria_ids).each do |criterion_id|
      judgments.create(criterion_id: criterion_id)
    end
  end

  def only_one_scorecard_per_judgeable
    if Scorecard.find_by(assignment: assignment, judgeable: judgeable).present?
      errors.add(:assignment_id, 'Only one scorecard allowed per judgeable entity')
    end
  end
end
