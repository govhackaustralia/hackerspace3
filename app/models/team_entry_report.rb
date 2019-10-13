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
      challenge_name
      entered_at
      checkpoint_name
      eligible
    ]
  end

  def preload_entities
    %i[challenge checkpoint project]
  end

  def row_values(entry)
    [
      entry.project.project_name,
      entry.project.team_name,
      entry.challenge.name,
      entry.created_at,
      entry.checkpoint.name,
      entry.eligible
    ]
  end
end
