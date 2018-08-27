module TeamManagement::TeamsHelper
  def competition_closed?
    team_time = Time.now.in_time_zone(@team.time_zone).to_formatted_s(:number)
    @competition.end_time.to_formatted_s(:number) < team_time
  end
end
