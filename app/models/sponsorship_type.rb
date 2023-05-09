# == Schema Information
#
# Table name: sponsorship_types
#
#  id             :bigint           not null, primary key
#  name           :string
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  competition_id :integer
#
# Indexes
#
#  index_sponsorship_types_on_competition_id  (competition_id)
#  index_sponsorship_types_on_position        (position)
#
class SponsorshipType < ApplicationRecord
  include Position

  belongs_to :competition

  has_many :sponsorships, dependent: :destroy
  has_many :sponsors, through: :sponsorships

  validates :name, :position, presence: true
  validates :position, uniqueness: { scope: :competition_id,
    message: 'already taken in this competition' }

  private

  def candidates_to_reposition
    return [] if competition.nil?

    competition.sponsorship_types
      .where(position: position..)
      .where.not(id: self)
      .order(position: :asc)
  end
end
