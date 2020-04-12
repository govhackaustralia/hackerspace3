# ENHANCEMENT: Extremely inefficient when used, rework. Move DB queries out.
# Can split into judge_compile and participant_compile.
class JudgeableScores
  def initialize(assignment, teams)
    @assignment = assignment
    @competition = assignment.competition
    @teams = teams
    @team_id_to_header = {}
    @user_team_ids = []
    @header_id_to_scores = {}
    @scoreable_scores_obj = {}
  end

  # Returns object for a particular scoreable assignment showing the status of
  # each of the potential teams to be judged.
  def compile
    compile_team_id_header_user_team_ids
    compile_header_id_to_scores
    compile_scoreable_scores
  end

  private

  def compile_team_id_header_user_team_ids
    if @assignment.title == JUDGE
      compile_judge_objects
    else
      compile_participant_objects
    end
  end

  def compile_judge_objects
    entries = Entry.where team: @teams, challenge: @assignment.assignable
    @team_headers = @assignment.headers.where scoreable: entries
    id_to_entry = {}
    entries.each { |entry| id_to_entry[entry.id] = entry }
    @team_headers.each do |header|
      entry = id_to_entry[header.scoreable_id]
      @team_id_to_header[entry.team_id] = header
    end
  end

  def compile_participant_objects
    @user_team_ids += @assignment.user.joined_teams.competition(@competition).pluck :id
    @team_headers = @assignment.headers.where scoreable: @teams
    @team_headers.each do |header|
      @team_id_to_header[header.scoreable_id] = header
    end
  end

  def compile_header_id_to_scores
    @team_headers.each { |header| @header_id_to_scores[header.id] = [] }
    scores = Score.where header: @team_headers
    scores.each do |score|
      @header_id_to_scores[score.header_id] << score.entry
    end
  end

  def compile_scoreable_scores
    @teams.each { |team| assign_verdict team }
    @scoreable_scores_obj
  end

  def assign_verdict(team)
    verdict = if @assignment.title != JUDGE && @user_team_ids.include?(team.id)
                'Your Team'
              elsif (header = @team_id_to_header[team.id]).nil?
                'Not Marked'
              elsif (scores = @header_id_to_scores[header.id]).include? nil
                'Incomplete'
              else
                scores.sum
              end
    @scoreable_scores_obj[team.id] = { display_score_status: verdict }
  end
end
