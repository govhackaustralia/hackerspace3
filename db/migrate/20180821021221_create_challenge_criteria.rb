class CreateChallengeCriteria < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_criteria do |t|
      t.integer :challenge_id
      t.integer :criterion_id
      t.text :description

      t.timestamps
    end
  end
end
