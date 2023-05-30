# frozen_string_literal: true

class PeoplesJudgesReport
  attr_reader :competition, :event_assignments

  def initialize(competition)
    @competition = competition
    @event_assignments = competition.assignments.event_assignments
  end

  def to_csv
    CSV.generate do |csv|
      csv << header_names
      all_peoples_judges.each do |assignment|
        csv << row_values(assignment)
      end
    end
  end

  private

  def header_names
    %w[
      judge_name
      judge_email
      scorecard_count
      average_score
    ]
  end

  def row_values(assignment)
    assignment.scores.extend(DescriptiveStatistics)
    [
      assignment.user.full_name,
      assignment.user.email,
      assignment.headers.count,
      assignment.scores.mean(&:entry)
    ]
  end

  def all_peoples_judges
    all_competition_judges - all_challenge_judges
  end

  def all_challenge_judges
    event_assignments.where(
      user_id: competition.competition_assignments.judges.pluck(:user_id),
    )
  end

  def all_competition_judges
    event_assignments.where(
      id: Header.where(
        assignment: event_assignments,
      ).pluck(:assignment_id),
    ).preload(:user, :headers, :scores)
  end
end
