class AddIdentifier < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :identifier, :string

    add_index :events, :identifier
  end
end
