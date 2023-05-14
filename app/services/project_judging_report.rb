# frozen_string_literal: true

class ProjectJudgingReport
  attr_accessor :competition, :projects, :judge_users

  def initialize(challenge)
    @competition = challenge.competition
    @judge_users = challenge.judge_users.preload(headers: %i[scoreable scores])
    @projects = challenge.published_projects_by_name.preload(team: :entries)
  end

  def to_csv
    CSV.generate do |csv|
      csv << header_names
      projects.to_a.product(judge_users).each do |project, judge_user|
        csv << row_values(project: project, judge_user: judge_user)
      end
    end
  end

  private

  def row_values(project:, judge_user:)
    [judge_user.display_name, project.project_name] +
      criteria_scores(project: project, judge_user: judge_user)
  end

  def criteria_scores(project:, judge_user:)
    criteria.map do |criterion|
      score_entry_for project: project, judge_user: judge_user, criterion: criterion
    end
  end

  def score_entry_for(project:, judge_user:, criterion:)
    score = score_for project: project, judge_user: judge_user, criterion: criterion
    return if score.nil?

    score.entry
  end

  def score_for(project:, judge_user:, criterion:)
    judge_user.headers.each do |header|
      next unless header.scoreable.in? scoreables_for project

      score = score_from header: header, criterion: criterion
      return score if score.present?
    end
    nil
  end

  def score_from(header:, criterion:)
    header.scores.find { |score| score.criterion_id == criterion.id }
  end

  def scoreables_for(project)
    [project.team, project.team.entries].flatten
  end

  def criteria
    @criteria ||= project_criteria + challenge_criteria
  end

  def project_criteria
    competition.project_criteria.order(:id)
  end

  def challenge_criteria
    competition.challenge_criteria.order(:id)
  end

  def header_names
    %w[judge_name project_name] + criteria.map(&:description)
  end
end
