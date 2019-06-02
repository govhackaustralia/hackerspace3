# ENHANCEMENT: Extremely inefficient when used, rework. Move DB queries out.
# Can split into judge_compile and participant_compile.
class JudgeableScores
  def initialize(assignment, teams)
    @assignment = assignment
    @teams = teams
    @team_id_to_scorecard = {}
    @user_team_ids = []
    @scorecard_id_to_scores = {}
    @judgeable_scores_obj = {}
  end

  # Returns object for a particular judgeable assignment showing the status of
  # each of the potential teams to be judged.
  def compile
    compile_team_id_scorecard_user_team_ids
    compile_scorecard_id_to_scores
    compile_judgeable_scores
  end

  private

  def compile_team_id_scorecard_user_team_ids
    if @assignment.title == JUDGE
      compile_judge_objects
    else
      compile_participant_objects
    end
  end

  def compile_judge_objects
    entries = Entry.where team: @teams, challenge: @assignment.assignable
    @team_scorecards = @assignment.scorecards.where judgeable: entries
    id_to_entry = {}
    entries.each { |entry| id_to_entry[entry.id] = entry }
    @team_scorecards.each do |scorecard|
      entry = id_to_entry[scorecard.judgeable_id]
      @team_id_to_scorecard[entry.team_id] = scorecard
    end
  end

  def compile_participant_objects
    @user_team_ids += @assignment.user.joined_teams.where(
      competition: @assignment.competition
    ).pluck :id
    @team_scorecards = @assignment.scorecards.where judgeable: @teams
    @team_scorecards.each do |scorecard|
      @team_id_to_scorecard[scorecard.judgeable_id] = scorecard
    end
  end

  def compile_scorecard_id_to_scores
    @team_scorecards.each { |scorecard| @scorecard_id_to_scores[scorecard.id] = [] }
    judgments = Judgment.where scorecard: @team_scorecards
    judgments.each do |judgment|
      @scorecard_id_to_scores[judgment.scorecard_id] << judgment.score
    end
  end

  def compile_judgeable_scores
    @teams.each { |team| assign_verdict team }
    @judgeable_scores_obj
  end

  def assign_verdict(team)
    verdict = if @assignment.title != JUDGE && @user_team_ids.include?(team.id)
                'Your Team'
              elsif (scorecard = @team_id_to_scorecard[team.id]).nil?
                'Not Marked'
              elsif (scores = @scorecard_id_to_scores[scorecard.id]).include? nil
                'Incomplete'
              else
                scores.sum
              end
    @judgeable_scores_obj[team.id] = { display_score_status: verdict }
  end
end
