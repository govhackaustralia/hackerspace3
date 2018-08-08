class CreateProjects < ActiveRecord::Migration[5.2]
  def change

    rename_column :team_project_versions, :team_project_id, :team_id
    rename_column :team_projects, :team_project_version_id, :current_project_id

    rename_table :team_project_versions, :projects
    rename_table :team_projects, :teams


  end
end
