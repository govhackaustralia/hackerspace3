# frozen_string_literal: true

require 'csv'
class DataSetImport
  class << self
    def csv(comp, file, import: false)
      CSV.open(file, headers: true).each do |row|
        reg = comp.regions.find_by_identifier(row['region'])
        raise StandardError, "\n\n######## Not found #{row['region']} ########\n\n" if reg.blank?

        puts "\nRegion: #{reg.competition.year}-#{reg.name}-#{reg.id}\n" \
             "Name: #{row['name']}\nDescription: #{row['description']}\nUrl: #{row['url']}\n"

        next unless import

        DataSet.create!(
          competition: comp,
          region: reg,
          name: row['name'],
          url: row['url'],
          description: row['description'],
        )
      end
      nil
    end
  end
end
