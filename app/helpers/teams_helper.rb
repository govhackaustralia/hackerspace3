module TeamsHelper
  def filter_teams(teams, term)
    return teams if term.nil?
    filtered_teams = []
    @teams.each do |team|
      team_string = "#{team.name} #{team.event.name}".downcase
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
end
