class SponsorshipType < ApplicationRecord
  belongs_to :competition
  has_many :sponsorships
end
