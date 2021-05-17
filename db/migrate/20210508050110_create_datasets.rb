class CreateDatasets < ActiveRecord::Migration[6.1]
  def change
    create_table :datasets do |t|
      t.string :name
      t.string :url
      t.text :description

      t.timestamps
    end
  end
end
