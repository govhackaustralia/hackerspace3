class AddToScorecard < ActiveRecord::Migration[5.2]
  def change
    add_column :scorecards, :included, :boolean, default: true
  end
end
