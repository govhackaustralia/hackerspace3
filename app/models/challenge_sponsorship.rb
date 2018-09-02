class ChallengeSponsorship < ApplicationRecord
  belongs_to :sponsor
  belongs_to :challenge
end
