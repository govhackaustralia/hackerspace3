class ProfileIdentifier < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :identifier, :string
    add_index :profiles, :identifier
  end
end
