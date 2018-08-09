class CreateDataSets < ActiveRecord::Migration[5.2]
  def change
    create_table :data_sets do |t|
      t.integer :region_id
      t.integer :competition_id
      t.string :name
      t.string :url
      t.text :description

      t.timestamps
    end
  end
end
