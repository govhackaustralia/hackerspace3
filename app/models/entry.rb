# == Schema Information
#
# Table name: entries
#
#  id            :bigint           not null, primary key
#  award         :string
#  eligible      :boolean
#  justification :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  challenge_id  :integer
#  checkpoint_id :integer
#  team_id       :integer
#
# Indexes
#
#  index_entries_on_award          (award)
#  index_entries_on_challenge_id   (challenge_id)
#  index_entries_on_checkpoint_id  (checkpoint_id)
#  index_entries_on_eligible       (eligible)
#  index_entries_on_team_id        (team_id)
#
class Entry < ApplicationRecord
  belongs_to :checkpoint
  belongs_to :challenge
  belongs_to :team

  has_one :competition, through: :team
  has_one :project, through: :team, source: :current_project
  has_one :event, through: :team
  has_one :team_region, through: :team, source: :region
  has_one :region, through: :challenge

  has_many :headers, dependent: :destroy, as: :scoreable

  validates :team_id, uniqueness: {
    scope: :challenge_id,
    message: 'Teams are not able to enter the same Challenge twice.'
  }
  validates :award, allow_nil: true, inclusion: { in: AWARD_NAMES }
  validate :entries_must_not_exceed_max_national_allowed_for_checkpoint,
           :teams_cannot_enter_challenges_they_are_not_eligible_for,
           on: :create

  after_create_commit :update_eligible

  scope :regional, lambda {
    joins(:region).where(regions: { category: Region::REGIONAL })
  }
  scope :national, lambda {
    joins(:region).where(
      regions: { category: [Region::INTERNATIONAL, Region::NATIONAL] }
    )
  }
  scope :winners, -> { where award: WINNER }
  scope :competition, lambda { |competition|
    joins(challenge: :region).where(regions: { competition: competition })
  }

  scope :published, -> { joins(:team).where(teams: { published: true }) }

  # Checks that a project has enough information entered for the entry to be
  # marked eligible, and then marks accordingly.
  def update_eligible(project = nil)
    project = team.current_project if project.nil?
    update(
      eligible: project.data_story.present? &&
      project.video_url.present? &&
      project.source_code_url.present?
    )
  end

  # Checks that a team has not entered the maximum number of regional challenges
  # at a given checkpoint.
  def entries_must_not_exceed_max_regional_allowed_for_checkpoint
    return unless challenge.region.regional?

    current_count = team.regional_challenges(checkpoint).count
    max_allowed = checkpoint.max_regional(region)
    return unless current_count >= max_allowed

    errors.add(
      :checkpoint_id,
      'Maximum Regional Challenges already entered for this Checkpoint'
    )
  end

  # Checks that a team has not entered the maximum number of national challenges
  # at a given checkpoint.
  def entries_must_not_exceed_max_national_allowed_for_checkpoint
    current_count = team.entries.count
    max_allowed = checkpoint.max_national(region)
    return unless current_count >= max_allowed

    errors.add(
      :checkpoint_id,
      'Maximum number of Challenges already entered for this Checkpoint'
    )
  end

  # Checks if the regional challenge a team is entering is a challenge in their
  # region.
  def teams_cannot_enter_challenges_they_are_not_eligible_for
    return if challenge.eligible_teams.include? team

    errors.add :challenge, 'Team not eligible to enter this challenge'
  end

  # Returns the average score obtained across judges of a challenge.
  # ENHANCEMENT: Probably not very DB efficient.
  def average_score
    cards = Header.where(scoreable: self)
    total_score = 0
    voted = 0
    cards.each do |card|
      next if (score = card.total_score).nil?

      total_score += score
      voted += 1
    end
    return (total_score / voted) unless voted.zero?
  end

  # Returns a count of the number of judges that have completed votes for an
  # entry.
  # ENHANCEMENT: Probably not very DB efficient.
  def judges_voted
    cards = Header.where(scoreable: self)
    voted = 0
    cards.each do |card|
      next if card.total_score.nil?

      voted += 1
    end
    voted
  end

  # Returns on objects of a teams challenge entries.
  # ENHANCEMENT: Not needed, move to active record preload.
  def self.team_id_entries(entries)
    entries = where(id: entries.uniq) if entries.instance_of?(Array)
    id_entries = {}
    entries.each { |entry| id_entries[entry.team_id] = entry }
    id_entries
  end
end
