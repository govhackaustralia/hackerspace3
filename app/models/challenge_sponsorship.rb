class ChallengeSponsorship < ApplicationRecord
  belongs_to :sponsor
  belongs_to :challenge

  validates :sponsor_id, uniqueness: { scope: :challenge_id,
                                       message: 'Sponsorship already exists.' }
end
