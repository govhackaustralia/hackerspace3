class CreateTeamDatasets < ActiveRecord::Migration[6.1]
  def change
    create_table :team_datasets do |t|
      t.integer :team_id
      t.integer :dataset_id
      t.text :description_of_use

      t.timestamps
    end

    add_index :team_datasets, [:team_id, :dataset_id]

    TeamDataSet.all.each do |team_data_set|
      dataset = Dataset.find_or_create_by! team_data_set.attributes.slice(
        'name',
        'url',
        'description'
      )
      TeamDataset.create!({
        team_id: team_data_set.team_id,
        dataset: dataset,
        description_of_use: team_data_set.description_of_use
      })
    end
  end
end
