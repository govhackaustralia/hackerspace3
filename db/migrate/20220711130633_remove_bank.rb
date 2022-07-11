class RemoveBank < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :bsb        , :string
    remove_column :users, :acc_number , :string
    remove_column :users, :acc_name   , :string
    remove_column :users, :branch_name, :string
  end
end
