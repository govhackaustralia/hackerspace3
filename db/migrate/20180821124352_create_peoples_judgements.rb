class CreatePeoplesJudgements < ActiveRecord::Migration[5.2]
  def change
    create_table :peoples_judgements do |t|
      t.integer :team_id
      t.integer :assignment_id
      t.integer :criterion_id
      t.integer :score

      t.timestamps
    end
  end
end
