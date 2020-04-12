class RenameScorecards < ActiveRecord::Migration[6.0]
  def change
    rename_table :scorecards, :headers
    rename_column :headers, :judgeable_type, :scoreable_type
    rename_column :headers, :judgeable_id, :scoreable_id
    rename_column :scores, :scorecard_id, :header_id
  end
end
