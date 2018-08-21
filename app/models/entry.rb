class Entry < ApplicationRecord
  belongs_to :team
  belongs_to :checkpoint
  belongs_to :challenge
  has_many :challenge_scorecards

  validates :justification, presence: true
end
