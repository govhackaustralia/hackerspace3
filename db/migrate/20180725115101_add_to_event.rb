class AddToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :type, :string
  end
end
