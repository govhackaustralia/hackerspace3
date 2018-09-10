class CreateScorecards < ActiveRecord::Migration[5.2]
  def change
    create_table :scorecards do |t|
      t.integer :assignment_id
      t.references :judgeable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
