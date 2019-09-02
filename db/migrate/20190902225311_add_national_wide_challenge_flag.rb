class AddNationalWideChallengeFlag < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :nation_wide, :boolean
    add_index :challenges, :nation_wide
  end
end
