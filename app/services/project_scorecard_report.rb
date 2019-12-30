class ProjectScorecardReport
  attr_reader :competition, :project_criteria, :challenge_criteria
  attr_accessor :messages

  def initialize(competition)
    @messages = []
    @competition = competition
    @project_criteria = competition.project_criteria
    @challenge_criteria = competition.challenge_criteria
  end

  def report
    @messages = []
    Scorecard.where(
      judgeable_type: 'Team',
      judgeable_id: competition.teams.pluck(:id)
    ).preload(:judgments, :judgeable, assignment: :user).each do |team_scorecard|
      check_for_duplicates team_scorecard
      challenge_scorecards = check_for_missing_scorecards(team_scorecard)
      check_for_all_missing_judgments team_scorecard, challenge_scorecards
    end
    puts messages.join("\n") unless Rails.env.test?
  end

  private

  def check_for_duplicates(scorecard)
    messages << "scorecard: #{scorecard.id}, DUPLICATE" if Scorecard.where(
      judgeable: scorecard.judgeable,
      assignment: scorecard.assignment
    ).count != 1
  end

  def check_for_missing_scorecards(team_scorecard)
    team = team_scorecard.judgeable
    judge_assignments = team_scorecard.user.judge_assignments.where(assignable: team.challenges)
    challenge_scorecards = Scorecard.where(assignment: judge_assignments, judgeable: team.entries)
    messages << "team_scorecard: #{team_scorecard.id}, MISSING CHALLENGE" if (judge_assignments.pluck(:id) - challenge_scorecards.pluck(:assignment_id)).present?
    challenge_scorecards
  end

  def check_for_all_missing_judgments(team_scorecard, challenge_scorecards)
    check_for_missing_judgments team_scorecard, project_criteria
    challenge_scorecards.each do |challenge_scorecard|
      check_for_missing_judgments challenge_scorecard, challenge_criteria
    end
  end

  def check_for_missing_judgments(scorecard, criteria)
    if scorecard.judgments.empty?
      messages << "scorecard: #{scorecard.id}, EMPTY"
    elsif (criteria.pluck(:id) - scorecard.judgments.pluck(:criterion_id)).present?
      messages << "scorecard: #{scorecard.id}, INCOMPLETE"
    end
  end
end
