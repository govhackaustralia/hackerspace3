class CreateTeamDataSets < ActiveRecord::Migration[5.2]
  def change
    create_table :team_data_sets do |t|
      t.integer :team_id
      t.string :name
      t.text :description
      t.text :description_of_use
      t.string :url

      t.timestamps
    end
  end
end
