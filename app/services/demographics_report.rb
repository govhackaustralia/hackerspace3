# frozen_string_literal: true

class DemographicsReport
  require 'csv'

  attr_reader :competition, :profiles, :fieldtype

  def initialize(competition, fieldtype)
    @competition = competition
    @fieldtype = fieldtype.downcase
    @profiles = @competition.profiles.preload(:employment_status).compact
  end

  # rubocop:disable
  def report
    grouped_data = case @fieldtype
    when 'age'
      @profiles.group_by(&:age)
    when 'gender'
      @profiles.group_by(&:gender)
    when 'first_peoples'
      @profiles.group_by(&:first_peoples)
    when 'disability'
      @profiles.group_by(&:disability)
    when 'education'
      @profiles.group_by(&:education)
    when 'employment'
      employment_grouped_data
    when 'postcode'
      @profiles.group_by(&:postcode)
    else
      raise 'field does not exist'
    end

    grouped_data.collect { |key, profile| data_set_object(key, profile) }
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w[
        input
        count
      ]
      report.each { |row| csv << row.values }
    end
  end

  private

  def employment_grouped_data
    grouped_data = EmploymentStatus.options.reduce({}) do |hash, option|
      hash.update(option => [])
    end
    @profiles.each do |profile|
      next if profile.employment_status.nil?

      EmploymentStatus.options.each do |option|
        next unless profile.employment_status.send(option)

        grouped_data[option] << profile
      end
    end
    grouped_data
  end

  def data_set_object(key, profile)
    {
      input: key,
      count: profile.count,
    }
  end
end
