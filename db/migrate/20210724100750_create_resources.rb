class CreateResources < ActiveRecord::Migration[6.1]
  def change
    create_table :resources do |t|
      t.integer :competition_id
      t.integer :category
      t.integer :position
      t.string :url
      t.string :name
      t.string :short_url

      t.timestamps
    end

    competition = Competition.find_by_year 2020

    data_portals = YAML.load_file "#{Rails.root}/app/views/resources/data_portals.yml"
    data_portals.each_with_index do |data_portal_hash, index|
      competition.resources.data_portal.create!(
        position: index + 1,
        name: data_portal_hash['name'],
        url: data_portal_hash['url'],
        short_url: data_portal_hash['short_url']
      )
    end

    tech = YAML.load_file "#{Rails.root}/app/views/resources/tech.yml"
    tech.each_with_index do |tech_hash, index|
      competition.resources.tech.create!(
        position: index + 1,
        name: tech_hash['name'],
        url: tech_hash['url'],
        short_url: tech_hash['short_url']
      )
    end
  end
end
