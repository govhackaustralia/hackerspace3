class CreateCheckpoints < ActiveRecord::Migration[5.2]
  def change
    create_table :checkpoints do |t|
      t.integer :competition_id
      t.datetime :end_time

      t.timestamps
    end
  end
end
