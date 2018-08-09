class Checkpoint < ApplicationRecord
  belongs_to :competition

  validates :end_time, presence: true
end
