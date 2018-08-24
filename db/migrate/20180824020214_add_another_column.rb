class AddAnotherColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :checkpoints, :name, :string
  end
end
