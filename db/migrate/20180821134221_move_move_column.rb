class MoveMoveColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :peoples_scorecards, :peoples_scorecard_id, :integer
    add_column :peoples_judgements, :peoples_scorecard_id, :integer
  end
end
