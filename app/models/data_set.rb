class DataSet < ApplicationRecord
  belongs_to :region
  belongs_to :competition

  validates :name, presence: true

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
