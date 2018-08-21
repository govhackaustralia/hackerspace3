class AddName < ActiveRecord::Migration[5.2]
  def change
    add_column :criteria, :name, :string
  end
end
