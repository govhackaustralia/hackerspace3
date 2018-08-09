class DataSet < ApplicationRecord
  belongs_to :region
  belongs_to :competition

  validates :name, presence: true
end
