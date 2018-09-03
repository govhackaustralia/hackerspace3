class Checkpoint < ApplicationRecord
  belongs_to :competition
  has_many :entries, dependent: :destroy

  validates :name, :end_time, :max_national_challenges,
            :max_regional_challenges, presence: true
end
