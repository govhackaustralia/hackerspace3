# == Schema Information
#
# Table name: challenge_sponsorships
#
#  id           :bigint           not null, primary key
#  challenge_id :integer
#  sponsor_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  approved     :boolean          default(FALSE)
#
class ChallengeSponsorship < ApplicationRecord
  belongs_to :sponsor
  belongs_to :challenge

  validates :sponsor_id, uniqueness: { scope: :challenge_id,
                                       message: 'Sponsorship already exists.' }
end
