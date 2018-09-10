module TeamsHelper
  def filter_teams(teams, term)
    return teams if term.nil?
    filtered_teams = []
    @teams.each do |team|
      team_obj = @id_teams_projects[team.id]
      team_name = team_obj[:current_project].team_name
      project_name = team_obj[:current_project].project_name
      event_name = team_obj[:event].name
      team_string = "#{team_name} #{project_name} #{event_name}".downcase
      filtered_teams << team if team_string.include? term.downcase
    end
    filtered_teams
  end

  def passed_checkpoints
    passed_checkpoints = []
    @checkpoints.each do |checkpoint|
      team_time = Time.now.in_time_zone(@team.time_zone).to_formatted_s(:number)
      next if checkpoint.end_time.to_formatted_s(:number) > team_time
      passed_checkpoints << checkpoint
    end
    passed_checkpoints
  end

  def team_name(team)
    @id_teams_projects[team.id][:current_project].team_name
  end

  def in_peoples_choice_window?
    @competition.peoples_choice_start < Time.now &&
      Time.now < @competition.peoples_choice_end
  end
end
