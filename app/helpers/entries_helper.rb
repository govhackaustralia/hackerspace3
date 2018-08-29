module EntriesHelper
  def filter_challenge_teams(checkpoint, term)
    team_ids = checkpoint.entries.where(challenge: @challenge).pluck(:team_id)
    teams = Team.where(id: team_ids)
    return teams if term.nil?
    filtered_teams = []
    teams.each do |team|
      team_string = "#{team.name} #{team.event.name}".downcase
      filtered_teams << team if team_string.include? term.downcase
    end
    filtered_teams
  end

  def passed_competition_checkpoints
    passed_checkpoints = []
    @checkpoints.each do |checkpoint|
      comp_time = Time.now.in_time_zone(LAST_TIME_ZONE).to_formatted_s(:number)
      next if checkpoint.end_time.to_formatted_s(:number) > comp_time
      passed_checkpoints << checkpoint
    end
    passed_checkpoints
  end
end
