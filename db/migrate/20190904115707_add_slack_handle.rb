class AddSlackHandle < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :slack, :string
  end
end
