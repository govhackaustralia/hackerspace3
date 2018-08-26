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
end
