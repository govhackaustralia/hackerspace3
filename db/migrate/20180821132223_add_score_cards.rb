class AddScoreCards < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_judgements, :challenge_scorecard_id, :integer
    rename_table :peoples_score_cards, :peoples_scorecards
    add_column :peoples_scorecards, :peoples_scorecard_id, :integer
  end
end
