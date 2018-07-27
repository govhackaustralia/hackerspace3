class Sponsor < ApplicationRecord
  has_many :assignments, as: :assignable
  belongs_to :competition
  has_many :sponsorships

  has_one_attached :logo
end
