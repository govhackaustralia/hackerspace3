class AddToProjectIdentifier < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :identifier, :string
  end
end
