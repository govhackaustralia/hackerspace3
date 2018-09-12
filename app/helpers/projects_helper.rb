module ProjectsHelper
  def filter_projects(term)
    return @projects if term.nil?
    filtered_projects = []
    @projects.each do |project|
      team_obj = @id_teams_projects[project.team_id]
      team_name = project.team_name
      project_name = project.project_name
      event_name = team_obj[:event].name
      team_string = "#{team_name} #{project_name} #{event_name}".downcase
      filtered_projects << project if team_string.include? term.downcase
    end
    filtered_projects
  end
end
