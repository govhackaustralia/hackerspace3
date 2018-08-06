class RenameEventType < ActiveRecord::Migration[5.2]
  def change
    rename_column :events, :type, :event_type
  end
end
