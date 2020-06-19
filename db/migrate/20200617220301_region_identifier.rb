class RegionIdentifier < ActiveRecord::Migration[6.0]
  def change
    add_column :regions, :identifier, :string
    add_index :regions, :identifier

    Region.all.each(&:touch)
  end
end
