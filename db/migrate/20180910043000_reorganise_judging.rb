class ReorganiseJudging < ActiveRecord::Migration[5.2]
  def change
    drop_table :challenge_criteria
    drop_table :challenge_judgements
    drop_table :challenge_scorecards
    drop_table :peoples_judgements
    drop_table :peoples_scorecards
  end
end
