class Criterion < ApplicationRecord
  belongs_to :competition

  validates :event_type, inclusion: { in: JUDGEMENT_CATEGORIES }
end
