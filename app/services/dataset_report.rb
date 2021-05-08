class DatasetReport
  require 'csv'

  attr_reader :datasets, :dataset_columns, :combined_columns

  def initialize(datasets)
    @datasets = datasets
    @dataset_columns = %w[name url description]
    @combined_columns = dataset_columns + ['projects']
  end

  # Outputs a CSV file of Data Set attributes.
  def to_csv
    CSV.generate do |csv|
      csv << combined_columns
      datasets.each do |dataset|
        dataset_values = dataset.attributes.values_at(*dataset_columns)
        csv << (dataset_values + [url_to_project_names[dataset.url]])
      end
    end
  end

  private

  # Compiles a hash of projects associated with a particular data set URL of
  # the form... { data_set_url : [project_name, ... ]}
  def url_to_project_names
    @url_to_project_names ||= begin
      dataset_urls = datasets.pluck(:url)
      team_data_sets = TeamDataSet.where(url: dataset_urls).preload(:current_project)
      url_to_project_names = {}
      dataset_urls.each { |url| url_to_project_names[url] = [] }
      team_data_sets.each do |team_data_set|
        url_to_project_names[team_data_set.url] << team_data_set.current_project.project_name
      end
      url_to_project_names
    end
  end
end
