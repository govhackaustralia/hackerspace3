class DataSet < ApplicationRecord
  belongs_to :region
  belongs_to :competition

  validates :name, presence: true

  def self.search(term)
    results = []
    DataSet.all.each do |data_set|
      data_set_string = "#{data_set.name} #{data_set.url} #{data_set.description}".downcase
      results << data_set if data_set_string.include? term.downcase
    end
    results
  end

  require 'csv'

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |data_set|
        csv << data_set.attributes.values
      end
    end
  end
end
