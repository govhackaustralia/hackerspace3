class Challenge < ApplicationRecord
  belongs_to :competition
  belongs_to :region
  has_many :sponsorships, as: :sponsorable
  has_many :entries

  validates :name, presence: true
  validates :name, uniqueness: true
end
