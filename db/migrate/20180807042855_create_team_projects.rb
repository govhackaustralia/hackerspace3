class CreateTeamProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :team_projects do |t|
      t.integer :event_id
      t.integer :team_project_version_id
      t.timestamps
    end
  end
end
