module ProjectsHelper
  def filter_projects(term)
    return @projects if term.nil?

    filtered_projects = []
    @projects.each do |project|
      next unless search_match(project, term)

      filtered_projects << project
    end
    filtered_projects
  end

  def search_match(project, term)
    team_name = project.team_name
    project_name = project.project_name
    event_name = project.event.name
    team_string = "#{team_name} #{project_name} #{event_name}".downcase
    team_string.include?(term.downcase) ? true : false
  end
end
