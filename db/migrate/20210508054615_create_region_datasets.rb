class CreateRegionDatasets < ActiveRecord::Migration[6.1]
  def change
    create_table :region_datasets do |t|
      t.integer :dataset_id
      t.integer :region_id

      t.timestamps
    end

    add_index(:region_datasets, [:dataset_id, :region_id])

    Region.all.each do |region|
      region.data_sets.each do |data_set|
        dataset = Dataset.find_or_create_by! data_set.attributes.slice(
          'name',
          'url',
          'description'
        )
        RegionDataset.create! region: region, dataset: dataset
      end
    end
  end
end
