class Score < ApplicationRecord
  belongs_to :header
  belongs_to :criterion

  validates :header_id, uniqueness: { scope: :criterion_id,
                                         message: 'Score already exists.' }
end
