class Event < ApplicationRecord
  has_many :assignments, as: :assignable
  belongs_to :region
  belongs_to :competition

  validates :name, presence: true
  validates :name, uniqueness: true
end
