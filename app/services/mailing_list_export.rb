# frozen_string_literal: true

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

  USER_COLUMNS2 = %w[
    id
    email
    full_name
    preferred_name
  ].freeze

  def to_csv
    CSV.generate do |csv|
      csv << (USER_COLUMNS + ['region'])
      competition.regions.each do |region|
        region_users(region).each do |user|
          csv << (user.attributes.values_at(*USER_COLUMNS) + [region.name])
        end
      end
    end
  end

  def to_csv_by_date
    CSV.generate do |csv|
      csv << (USER_COLUMNS2 + ['region'])

      # Collect all users across all regions
      all_users = competition.regions.flat_map do |region|
        region_users_all(region)
      end.uniq

      # Sort users by ID in descending order
      sorted_users = all_users.sort_by(&:id).reverse

      # Write sorted users to CSV
      sorted_users.each do |user|
        # Assuming you still want to include the region for each user
        region_name = competition.regions.find { |region| region_users_all(region).include?(user) }&.name
        csv << (user.attributes.values_at(*USER_COLUMNS2) + [region_name])
      end
    end
  end

  private

  def region_users(region)
    region.events.preload(:users).map do |event|
      event.users.mailing_list
    end.flatten.uniq
  end

  def region_users_all(region)
    region.events.preload(:users).map(&:users).flatten.uniq
  end
end
