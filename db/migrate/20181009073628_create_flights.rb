class CreateFlights < ActiveRecord::Migration[5.2]
  def change
    create_table :flights do |t|
      t.integer :event_id
      t.string :description
      t.string :direction

      t.timestamps
    end
  end
end
