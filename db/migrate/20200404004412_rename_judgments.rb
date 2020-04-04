class RenameJudgments < ActiveRecord::Migration[6.0]
  def change
    rename_table :judgments, :scores
    rename_column :scores, :score, :entry
  end
end
