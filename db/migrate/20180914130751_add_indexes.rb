class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :judgments, :scorecard_id
    add_index :judgments, :criterion_id
    add_index :projects, :identifier
    add_index :scorecards, :assignment_id
    add_index :scorecards, :included
  end
end
