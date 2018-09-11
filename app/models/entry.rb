class Entry < ApplicationRecord
  belongs_to :team
  belongs_to :checkpoint
  belongs_to :challenge
  has_many :scorecards, dependent: :destroy, as: :judgeable

  validates :justification, presence: true

  validates :team_id, uniqueness: { scope: :challenge_id,
                                    message: 'Teams are not able to enter the same Challenge twice.' }

  validate :entries_must_not_exceed_max_regional_allowed_for_checkpoint,
           :entries_must_not_exceed_max_national_allowed_for_checkpoint,
           :teams_cannot_enter_regional_challenges_from_regions_other_than_their_own, on: :create

  after_create :update_eligible

  def update_eligible(project = nil)
    project = team.current_project if project.nil?
    if project.data_story.present? && project.video_url.present? && project.source_code_url.present?
      update(eligible: true)
    else
      update(eligible: false)
    end
  end

  def entries_must_not_exceed_max_regional_allowed_for_checkpoint
    return if challenge.region.national?
    current_count = team.regional_challenges(checkpoint).count
    max_allowed = checkpoint.max_regional_challenges
    if current_count >= max_allowed
      errors.add(:checkpoint_id, 'Maximum Regional Challenges already entered for this Checkpoint')
    end
  end

  def entries_must_not_exceed_max_national_allowed_for_checkpoint
    return unless challenge.region.national?
    current_count = team.national_challenges(checkpoint).count
    max_allowed = checkpoint.max_national_challenges
    if current_count >= max_allowed
      errors.add(:checkpoint_id, 'Maximum National Challenges already entered for this Checkpoint')
    end
  end

  def teams_cannot_enter_regional_challenges_from_regions_other_than_their_own
    challenge_region = challenge.region
    return if challenge_region.national?
    if team.region != challenge_region
      errors.add(:checkpoint_id, 'Teams are not able to enter Challenges in Regions other than their own')
    end
  end

  def average_score
    cards = Scorecard.where(judgeable: self)
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
    cards = Scorecard.where(judgeable: self)
    voted = 0
    cards.each do |card|
      next if card.total_score.nil?
      voted += 1
    end
    voted
  end
end
