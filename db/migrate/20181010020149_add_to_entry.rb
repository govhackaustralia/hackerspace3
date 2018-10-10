class AddToEntry < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :award, :string
    add_index :entries, :award

    add_column :regions, :award_release, :datetime

    add_column :users, :bsb, :string
    add_column :users, :acc_number, :string
    add_column :users, :acc_name, :string
    add_column :users, :branch_name, :string
  end
end
