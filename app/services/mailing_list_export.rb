class MailingListExport
  attr_reader :competition

  def initialize(competition)
    @competition = competition
  end

  USER_COLUMNS = %w[
    email
    full_name
    preferred_name
  ].freeze

  def to_csv
    CSV.generate do |csv|
      csv << USER_COLUMNS + ['region']
      competition.regions.each do |region|
        region_users(region).each do |user|
          csv << user.attributes.values_at(*USER_COLUMNS) + [region.name]
        end
      end
    end
  end

  private

  def region_users(region)
    region.events.preload(:users).map do |event|
      event.users.mailing_list
    end.flatten.uniq
  end
end
