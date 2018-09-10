class CreateJudgments < ActiveRecord::Migration[5.2]
  def change
    create_table :judgments do |t|
      t.integer :scorecard_id
      t.integer :criterion_id
      t.integer :score

      t.timestamps
    end
  end
end
