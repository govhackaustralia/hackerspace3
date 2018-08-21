class CreateChallengeJudgements < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_judgements do |t|
      t.integer :entry_id
      t.integer :assignment_id
      t.integer :challenge_criterion_id
      t.integer :score

      t.timestamps
    end
  end
end
