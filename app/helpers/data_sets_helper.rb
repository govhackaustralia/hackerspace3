module DataSetsHelper
  def filter_data_sets(data_sets, term)
    return data_sets if term.nil?
    filtered_data_sets = []
    @data_sets.each do |data_set|
      data_set_string = "#{data_set.name} #{data_set.description}" +
                        "#{@id_regions[data_set.region_id].name}".downcase
      filtered_data_sets << data_set if data_set_string.include? term.downcase
    end
    filtered_data_sets
  end
end
