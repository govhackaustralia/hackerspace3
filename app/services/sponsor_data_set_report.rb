# frozen_string_literal: true

class SponsorDataSetReport
  require 'csv'

  attr_reader :competition, :data_sets, :accounted_team_data_sets

  def initialize(competition)
    @competition = competition
    @data_sets = competition.data_sets.preload(:challenges, :sponsors)
    @accounted_team_data_sets = nil
  end

  def report
    @accounted_team_data_sets = []
    data_sets.collect { |data_set| data_set_result(data_set) }
  end

  def unaccounted_team_data_set_count
    raise 'Run #report first!' if accounted_team_data_sets.nil?

    (competition.team_data_sets.pluck(:id) - accounted_team_data_sets).length
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
    accounted_team_data_sets << team_data_sets.pluck(:id)
    data_set_object(data_set, team_data_sets)
  end

  def data_set_object(data_set, team_data_sets)
    {
      data_set_name: data_set.name,
      challenges: data_set.challenges.pluck(:name),
      sponsors: data_set.sponsors.pluck(:name),
      team_data_sets_count: team_data_sets.length,
      teams_count: team_data_sets.pluck(:team_id).uniq.length,
    }
  end
end
