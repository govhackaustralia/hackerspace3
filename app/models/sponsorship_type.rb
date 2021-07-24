class SponsorshipType < ApplicationRecord
  belongs_to :competition

  has_many :sponsorships, dependent: :destroy
  has_many :sponsors, through: :sponsorships

  before_validation :make_a_space!

  validates :name, :position, presence: true
  validates :position, uniqueness: { scope: :competition_id,
    message: 'already taken in this competition' }

  private

  def make_a_space!
    SponsorshipType.transaction { candidates_to_update.each(&:save!) }
  end

  def candidates_to_update
    counter = position
    candidates_to_consider.select do |sponsorship_type|
      next false unless sponsorship_type.position == counter

      counter += 1
      sponsorship_type.position = counter
    end
  end

  def candidates_to_consider
    return [] if competition.nil?

    competition.sponsorship_types
      .where(position: position..)
      .where.not(id: self)
      .order(position: :asc)
  end
end
