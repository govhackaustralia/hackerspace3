# == Schema Information
#
# Table name: challenge_sponsorships
#
#  id           :bigint           not null, primary key
#  approved     :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  challenge_id :integer
#  sponsor_id   :integer
#
# Indexes
#
#  index_challenge_sponsorships_on_challenge_id  (challenge_id)
#  index_challenge_sponsorships_on_sponsor_id    (sponsor_id)
#
class ChallengeSponsorship < ApplicationRecord
  belongs_to :sponsor
  belongs_to :challenge

  validates :sponsor_id, uniqueness: { scope: :challenge_id,
                                       message: 'Sponsorship already exists.' }
end
