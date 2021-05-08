class CreateChallengeDatasets < ActiveRecord::Migration[6.1]
  def change
    create_table :challenge_datasets do |t|
      t.integer :dataset_id
      t.integer :challenge_id

      t.timestamps
    end

    add_index :challenge_datasets, [:dataset_id, :challenge_id]

    ChallengeDataSet.all.preload(:data_set).each do |challenge_data_set|
      dataset = Dataset.find_or_create_by! challenge_data_set.data_set.attributes.slice(
        'name',
        'url',
        'description'
      )
      ChallengeDataset.create! challenge_id: challenge_data_set.challenge_id, dataset: dataset
    end
  end
end
