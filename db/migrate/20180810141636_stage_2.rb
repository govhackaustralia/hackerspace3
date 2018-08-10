class Stage2 < ActiveRecord::Migration[5.2]
  def change

    rename_column :events, :type, :event_type

    create_table :challenges do |t|
      t.integer :region_id
      t.integer :competition_id
      t.string :name
      t.text :short_desc
      t.text :long_desc
      t.text :eligibility
      t.string :video_url
      t.string :data_set_url
      t.boolean :approved

      t.timestamps
    end

    create_table :checkpoints do |t|
      t.integer :competition_id
      t.datetime :end_time

      t.timestamps
    end

    create_table :data_sets do |t|
      t.integer :region_id
      t.integer :competition_id
      t.string :name
      t.string :url
      t.text :description

      t.timestamps
    end

    create_table :entries do |t|
      t.integer :team_id
      t.integer :challenge_id
      t.integer :checkpoint_id
      t.text :justification
      t.boolean :eligible

      t.timestamps
    end

    create_table :projects do |t|
      t.integer :team_id
      t.string :team_name
      t.text :description
      t.text :data_story
      t.string :source_code_url
      t.string :video_url
      t.string :homepage_url

      t.timestamps
    end

    create_table :team_data_sets do |t|
      t.integer :team_id
      t.string :name
      t.text :description
      t.text :description_of_use
      t.string :url

      t.timestamps
    end

    create_table :teams do |t|
      t.integer :event_id
      t.integer :project_id

      t.timestamps
    end
  end
end
