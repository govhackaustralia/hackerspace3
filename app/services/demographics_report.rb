class DemographicsReport
  require 'csv'

  attr_reader :competition, :profiles, :fieldtype

  def initialize(competition, fieldtype )
    @competition = competition
    @fieldtype = fieldtype.downcase 
    @profiles = @competition.profiles.compact
  end

  def report 
    case @fieldtype
    when 'age'
      grouped_data = @profiles.group_by(&:age)
    when 'gender'
      grouped_data = @profiles.group_by(&:gender)
    when 'first_peoples'
      grouped_data = @profiles.group_by(&:first_peoples)
    when 'disability'
      grouped_data = @profiles.group_by(&:disability)
    when 'education'
      grouped_data = @profiles.group_by(&:education)
    when 'employment'
      grouped_data = @profiles.group_by(&:employment)
    when 'postcode'
      grouped_data = @profiles.group_by(&:postcode)
    else
      raise 'field does not exist'
    end

    grouped_data.collect { |key, profile| data_set_object(key,profile)  }
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

  # private


  def data_set_object(key, profile)
    {
      input: key,
      count: profile.count
      
    }
  end


end
