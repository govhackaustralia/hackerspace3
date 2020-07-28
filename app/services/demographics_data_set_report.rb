class DemographicsDataSetReport
  require 'csv'

  attr_reader :competition, :data_sets, :accounted_team_data_sets

  def initialize(competition)
    @competition = competition
    @data_sets = @competition.users.preload(:profile)
  end

  def report 
    data_sets.collect { |data_set| data_set_object(data_set) }
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w[
        user_id
        full_name
        id
        age
        gender
        first_peoples
        disability
        education 
        employment
        postcode

      ]
      report.each { |row| csv << row.values }
    end
  end

  # private


  def data_set_object(user)
    {
      user_id: user.id,
      full_name: user.full_name,
      id: user.profile.id,
      age: user.profile.age,
      gender: user.profile.gender,
      first_peoples: user.profile.first_peoples,
      disability: user.profile.disability,
      education: user.profile.education,
      employment: user.profile.employment,
      postcode: user.profile.postcode
    }
  end
end
