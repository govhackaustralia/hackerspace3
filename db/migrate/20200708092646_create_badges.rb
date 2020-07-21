class CreateBadges < ActiveRecord::Migration[6.0]
  def change
    create_table :badges do |t|
      t.integer :competition_id
      t.string :name
      t.string :identifier
      t.integer :capacity

      t.timestamps
    end

    add_index :badges, :identifier
  end
end
