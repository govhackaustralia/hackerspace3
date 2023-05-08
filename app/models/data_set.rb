# == Schema Information
#
# Table name: data_sets
#
#  id          :bigint           not null, primary key
#  region_id   :integer
#  name        :string
#  url         :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class DataSet < ApplicationRecord
  belongs_to :region
  has_one :competition, through: :region

  has_many :challenge_data_sets
  has_many :challenges, through: :challenge_data_sets
  has_many :sponsors, through: :challenges
  has_many :visits, as: :visitable, dependent: :destroy

  scope :search, ->(term) {
    where 'data_sets.name ILIKE ? OR url ILIKE ? OR description ILIKE ?',
    "%#{term}%", "%#{term}%", "%#{term}%"
  }

  validates :name, presence: true

  require 'csv'

  # Outputs a CSV file of Data Set attributes.
  def self.to_csv(competition)
    data_set_columns = %w[name url description]
    combined = data_set_columns + ['projects']
    data_sets = competition.data_sets
    url_to_project_names = data_set_project_helper data_sets
    CSV.generate do |csv|
      csv << combined
      data_sets.each do |data_set|
        data_set_values = data_set.attributes.values_at(*data_set_columns)
        csv << (data_set_values + [url_to_project_names[data_set.url]])
      end
    end
  end

  # Compiles a hash of projects associated with a particular data set URL of
  # the form... { data_set_url : [project_name, ... ]}
  # ENHANCEMENT: Should go elsewhere?
  def self.data_set_project_helper(data_sets)
    data_set_urls = data_sets.pluck(:url)
    team_data_sets = TeamDataSet.where(url: data_set_urls).preload(:current_project)
    url_to_project_names = {}
    data_set_urls.each { |url| url_to_project_names[url] = [] }
    team_data_sets.each do |team_data_set|
      url_to_project_names[team_data_set.url] << team_data_set.current_project.project_name
    end
    url_to_project_names
  end
end
