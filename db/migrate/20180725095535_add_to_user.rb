class AddToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :organisation_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :how_did_you_hear, :text
  end
end
