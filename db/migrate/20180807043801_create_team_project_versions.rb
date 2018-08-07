class CreateTeamProjectVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :team_project_versions do |t|
      t.integer :team_project_id
      t.string :team_name
      t.text :description
      t.text :data_story
      t.string :source_code_url
      t.string :video_url
      t.string :homepage_url

      t.timestamps
    end
  end
end
