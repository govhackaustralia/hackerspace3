class RemoveUserImg < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :govhack_img, :string
    remove_column :users, :gravitar_img, :string
  end
end
