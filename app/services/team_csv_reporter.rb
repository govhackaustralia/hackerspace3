class TeamCsvReporter
  # Generates a CSV file for all participating team members and their
  # attributes.
  def self.all_members_to_csv(competition, options = {})
    columns = %w[team_name project_name event_name full_name email title]
    CSV.generate(options) do |csv|
      csv << columns
      competition.competition_assignments.team_participants.preload(
            :user, assignable: %i[current_project event]).each do |assignment|
        project = assignment.assignable.current_project
        user = assignment.user
        csv << [
          project.team_name,
          project.project_name,
          assignment.assignable.event.name,
          user.full_name,
          user.email,
          assignment.title
        ]
      end
    end
  end
end
