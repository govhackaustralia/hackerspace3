class AddDefaultApproved < ActiveRecord::Migration[5.2]
  def change
    change_column :challenges, :approved, :boolean, :default => false
  end
end
