class CreatePortals < ActiveRecord::Migration[6.1]
  def change
    create_table :portals do |t|
      t.string :portable_type
      t.integer :portable_id
      t.integer :dataset_id

      t.timestamps
    end

    add_index :portals, [:portable_type, :portable_id, :dataset_id]

    create_table :extras do |t|
      t.text :entry
      t.integer :portal_id

      t.timestamps
    end

    add_index :extras, :portal_id

    # Create Competition Datasets
    Competition.all.each do |competition|
      YAML.load_file("#{Rails.root}/app/views/resources/data_portals.yml").each do |data_portal|
        dataset = Dataset.find_or_create_by! data_portal.slice(
          'name',
          'url',
        )
        portal = Portal.create!(
          portable: competition,
          dataset: dataset
        )
        Extra.create! entry: data_portal['short_url'], portal: portal
      end
    end
  end
end
