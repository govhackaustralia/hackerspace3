class Scorecard < ApplicationRecord
  belongs_to :judgeable, polymorphic: true
  belongs_to :assignment

  has_one :user, through: :assignment

  has_many :judgments, dependent: :destroy
  has_many :assignment_scorecards, through: :assignment, source: :scorecards
  has_many :assignment_judgments, through: :assignment_scorecards, source: :judgments

  validates :assignment, uniqueness: { scope: :judgeable,
                                       message: 'Only one scorecard allowed per judgeable entity' }

  validate :cannot_judge_your_own_team

  scope :included, -> { where(included: true) }

  def update_judgments
    criteria_ids = Competition.current.criteria.where(category: type).pluck(:id)
    score_card_criteria_ids = judgments.pluck(:criterion_id)
    (criteria_ids - score_card_criteria_ids).each do |criterion_id|
      judgments.create(criterion_id: criterion_id)
    end
  end

  def type
    return CHALLENGE if judgeable_type == 'Entry'

    PROJECT
  end

  def cannot_judge_your_own_team
    return if judgeable_type == 'Entry' || judgeable.users.exclude?(user)

    errors.add(:assignment_id, 'Participants are not permitted to vote for a team they are a member of.')
  end

  def total_score
    score = 0
    judgments.each do |judgment|
      return nil if judgment.score.nil?

      score += judgment.score
    end
    score
  end

  def display_score
    score = total_score
    return 'Scorecard Incomplete' if score.nil?

    score
  end

  def max_score
    judgeable.competition.score_total type
  end

  def self.participant_scorecards(teams, include_judges)
    # Returns all project based judging scorecards.
    all_scorecards = Scorecard.included.where(judgeable: teams).order(:assignment_id).preload(:judgments)
    return all_scorecards if include_judges

    # if include judges false finds all the project scorecard associated
    # with judges and removes them from the set.
    judge_user_ids = Assignment.where(title: JUDGE).pluck(:user_id)
    judge_assignment_ids = Assignment.where(title: EVENT_ASSIGNMENTS, user_id: judge_user_ids).pluck(:id)
    judge_scorecards = Scorecard.included.where(assignment_id: judge_assignment_ids)
    all_scorecards - judge_scorecards
  end

  # Compiles statistics on a team's (practically) project scorecards.
  # Returns an object of type { team_id: { scorecards: [:id, ...],
  # scores: [:mean_score, ...], total_card_count: :count }, ... }
  def self.region_scorecard_helper(teams, type, include_judges)
    # Retrieves the relevant scorecards, all off them unless include judges is
    # false then removes those.
    scorecards = participant_scorecards(teams, include_judges)

    # Creates an object for every published team so with field scorecards,
    # scores.
    region_scorecard_helper = {}
    teams.each do |team|
      region_scorecard_helper[team.id] = { scorecards: [], scores: [] }
    end

    scorecards.each do |scorecard|
      region_scorecard_helper[scorecard.judgeable_id][:scorecards] << scorecard.id
    end

    scorecards.each do |scorecard|
      scorecard_count = region_scorecard_helper[scorecard.judgeable_id][:scorecards].count
      region_scorecard_helper[scorecard.judgeable_id][:total_card_count] = scorecard_count
    end

    # Will not 'scores' (a scorecards judgments) that have fewer entries than
    # they are supposed to, have entries that are incomplete
    correct_score_count = Competition.current.criteria.where(category: type).count
    scorecards.each do |scorecard|
      scores = scorecard.judgments.pluck(:score)
      next unless scores.count == correct_score_count
      next if scores.include? nil

      region_scorecard_helper[scorecard.judgeable_id][:scores] << scores.mean
    end
    region_scorecard_helper
  end

  def self.team_scorecard_helper(scorecards)
    judgments = Judgment.where(scorecard: scorecards).order(:criterion_id)
    team_scorecard_helper = {}
    scorecards.each do |scorecard|
      team_scorecard_helper[scorecard.id] = { scores: [] }
    end
    judgments.each do |judgment|
      team_scorecard_helper[judgment.scorecard_id][:scores] << judgment.score
    end
    team_scorecard_helper
  end
end
