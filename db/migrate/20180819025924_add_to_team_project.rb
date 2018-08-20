class AddToTeamProject < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :published, :boolean, default: false
    add_column :projects, :user_id, :integer
  end
end
