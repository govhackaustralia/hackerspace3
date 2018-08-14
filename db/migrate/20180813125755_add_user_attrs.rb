class AddUserAttrs < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :registration_type, :string
    add_column :users, :parent_guardian, :string
    add_column :users, :request_not_photographed, :boolean, default: false
    add_column :users, :data_cruncher, :boolean, default: false
    add_column :users, :coder, :boolean, default: false
    add_column :users, :creative, :boolean, default: false
    add_column :users, :facilitator, :boolean, default: false
  end
end
