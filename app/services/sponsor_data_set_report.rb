class SponsorDataSetReport
  attr_reader :competition, :data_sets
  require 'csv'

  def initialize(competition)
    @competition = competition
    @data_sets = competition.data_sets.preload(:challenges, :sponsors)
  end

  def report
    data_sets.collect { |data_set| data_set_result(data_set) }
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w[
        data_set_name
        challenges
        sponsors
        team_data_sets_count
        teams_count
      ]
      report.each { |row| csv << row.values }
    end
  end

  private

  def data_set_result(data_set)
    team_data_sets = competition.team_data_sets.where(url: data_set.url)
    {
      data_set_name: data_set.name,
      challenges: data_set.challenges.pluck(:name),
      sponsors: data_set.sponsors.pluck(:name),
      team_data_sets_count: team_data_sets.length,
      teams_count: team_data_sets.pluck(:team_id).uniq.length
    }
  end
end
