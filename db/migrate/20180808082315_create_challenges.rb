class CreateChallenges < ActiveRecord::Migration[5.2]
  def change
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
  end
end
