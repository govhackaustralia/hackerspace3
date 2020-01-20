class TeamEntryReport
  attr_reader :competition

  def initialize(competition)
    @competition = competition
  end

  def to_csv
    CSV.generate do |csv|
      csv << header_names
      competition.entries.preload(*preload_entities).each do |entry|
        csv << row_values(entry)
      end
    end
  end

  private

  def header_names
    %w[
      project_name
      team_name
      event_name
      challenge_name
      time_zone
      entered_at
      checkpoint_name
      eligible
    ]
  end

  def preload_entities
    %i[challenge checkpoint project team_region event]
  end

  def row_values(entry)
    [
      entry.project.project_name,
      entry.project.team_name,
      entry.event.name,
      entry.challenge.name,
      (time_zone = entry.team_region.time_zone),
      entry.created_at.in_time_zone(time_zone),
      entry.checkpoint.name,
      entry.eligible
    ]
  end
end
