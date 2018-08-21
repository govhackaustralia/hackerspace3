class CreatePeoplesScoreCards < ActiveRecord::Migration[5.2]
  def change
    create_table :peoples_score_cards do |t|
      t.integer :team_id
      t.integer :assignment_id

      t.timestamps
    end

    remove_column :peoples_judgements, :team_id, :integer
    remove_column :peoples_judgements, :assignment_id, :integer
  end
end
