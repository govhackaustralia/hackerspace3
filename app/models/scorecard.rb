class Scorecard < ApplicationRecord
  has_many :judgments, dependent: :destroy

  belongs_to :assignment
  belongs_to :judgeable, polymorphic: true

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
end
