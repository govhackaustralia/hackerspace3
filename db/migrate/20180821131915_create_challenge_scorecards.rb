class CreateChallengeScorecards < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_scorecards do |t|
      t.integer :entry_id
      t.integer :assignment_id

      t.timestamps
    end

    remove_column :challenge_judgements, :entry_id, :integer
    remove_column :challenge_judgements, :assignment_id, :integer
  end
end
