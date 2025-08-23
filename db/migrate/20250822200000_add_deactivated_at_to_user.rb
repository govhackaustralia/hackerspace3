class AddDeactivatedAtToUser < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :deactivated_at, :datetime
  end
  def down
    remove_column :users, :deactivated_at
  end
end
