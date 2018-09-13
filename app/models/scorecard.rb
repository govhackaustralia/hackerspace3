class Scorecard < ApplicationRecord
  has_many :judgments, dependent: :destroy

  belongs_to :assignment
  has_one :user, through: :assignment
  belongs_to :judgeable, polymorphic: true

  validate :only_one_scorecard_per_judgeable, :cannot_judge_your_own_team

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

  def only_one_scorecard_per_judgeable
    if Scorecard.find_by(assignment: assignment, judgeable: judgeable).present?
      errors.add(:assignment_id, 'Only one scorecard allowed per judgeable entity')
    end
  end

  def cannot_judge_your_own_team
    return if judgeable_type == 'Entry'
    if judgeable.users.include? user
      errors.add(:assignment_id, 'Participants are not permitted to vote for a team they are a member in.')
    end
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

  def self.team_id_scorecards(teams, type)
    scorecards = Scorecard.where(judgeable: teams)
    team_id_scorecards = {}
    teams.each do |team|
      team_id_scorecards[team.id] = { scorecards: [], scores: [] }
    end

    scorecards.each do |scorecard|
      team_id_scorecards[scorecard.judgeable_id][:scorecards] << scorecard.id
    end

    scorecards.each do |scorecard|
      scorecard_count = team_id_scorecards[scorecard.judgeable_id][:scorecards].count
      team_id_scorecards[scorecard.judgeable_id][:total_card_count] = scorecard_count
    end

    judgments = Judgment.where(scorecard: scorecards)
    id_scorecard_scores = {}
    scorecards.each { |scorecard| id_scorecard_scores[scorecard.id] = [] }
    judgments.each do |judgment|
      id_scorecard_scores[judgment.scorecard_id] << judgment.score
    end

    correct_score_count = Competition.current.criteria.where(category: type).count
    scorecards.each do |scorecard|
      scores = id_scorecard_scores[scorecard.id]
      next unless scores.count == correct_score_count
      next if scores.include? nil
      next unless scorecard.included
      team_id_scorecards[scorecard.judgeable_id][:scores] << scores.mean
    end
    puts "TEAM_ID_SCORECARDS #{team_id_scorecards}"
    team_id_scorecards
  end
end
