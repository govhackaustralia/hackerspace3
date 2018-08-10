class Checkpoint < ApplicationRecord
  belongs_to :competition
  has_many :entries

  validates :end_time, presence: true
end
