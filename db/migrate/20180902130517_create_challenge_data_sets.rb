class CreateChallengeDataSets < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_data_sets do |t|
      t.integer :challenge_id
      t.integer :data_set_id

      t.timestamps
    end

    remove_column :challenges, :data_set_url, :string
  end
end
