class TeamMemberReport
  attr_accessor :competition

  # Generates a CSV file for all participating team members and their
  # attributes.
  def initialize(competition)
    @competition = competition
  end

  def to_csv
    CSV.generate do |csv|
      csv << header_names
      competition.competition_assignments.team_participants.preload(
          *preload_entities).each do |assignment|
        csv << row_values(assignment)
      end
    end
  end

  private

  def header_names
    %w[
      team_name
      project_name
      event_name
      full_name
      email
      title
    ]
  end

  def preload_entities
    [:user, assignable: %i[current_project event]]
  end

  def row_values(assignment)
    project = assignment.assignable.current_project
    user = assignment.user
    [
      project.team_name,
      project.project_name,
      assignment.assignable.event.name,
      user.full_name,
      user.email,
      assignment.title
    ]
  end
end
