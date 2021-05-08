class DataSet < ApplicationRecord
  belongs_to :region
  has_one :competition, through: :region

  has_many :challenge_data_sets
  has_many :challenges, through: :challenge_data_sets
  has_many :sponsors, through: :challenges

  validates :name, presence: true
end
