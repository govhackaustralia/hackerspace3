class Entry < ApplicationRecord
  belongs_to :team
  belongs_to :checkpoint
  belongs_to :challenge

  validates :justification, presence: true
end
