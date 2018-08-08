class RenameCurrentProject < ActiveRecord::Migration[5.2]
  def change
    rename_column :teams, :current_project_id, :project_id
  end
end
