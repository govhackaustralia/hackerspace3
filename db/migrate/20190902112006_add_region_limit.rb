class AddRegionLimit < ActiveRecord::Migration[5.2]
  def change
    create_table :region_limits do |t|
      t.integer :region_id
      t.integer :checkpoint_id
      t.integer :max_regional_challenges
      t.integer :max_national_challenges

      t.timestamps
    end

    add_index :region_limits, :region_id
    add_index :region_limits, :checkpoint_id
  end
end
