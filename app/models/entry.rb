class Entry < ApplicationRecord
  belongs_to :team
  belongs_to :checkpoint
  belongs_to :challenge
  has_many :challenge_scorecards

  validates :justification, presence: true

  validates :challenge_id, uniqueness: { scope: :team_id,
    message: "Teams are not able to enter the same Challenge twice." }

  def average_score
    cards = ChallengeScorecard.where(entry: self)
    total_score = 0
    voted = 0
    cards.each do |card|
      next if (score = card.total_score).nil?
      total_score += score
      voted += 1
    end
    return (total_score / voted) unless voted.zero?
  end

  def judges_voted
    cards = ChallengeScorecard.where(entry: self)
    voted = 0
    cards.each do |card|
      next if card.total_score.nil?
      voted += 1
    end
    voted
  end
end
