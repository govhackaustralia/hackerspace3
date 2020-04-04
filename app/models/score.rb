class Score < ApplicationRecord
  belongs_to :scorecard
  belongs_to :criterion

  validates :scorecard_id, uniqueness: { scope: :criterion_id,
                                         message: 'Score already exists.' }
end
