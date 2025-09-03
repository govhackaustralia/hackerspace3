class RemoveUserDeactivatedAt < ActiveRecord::Migration[7.0]
  def up
    remove_column :users, :deactivated_at
  end
  def down
    add_column :users, :deactivated_at, :datetime
  end
end
