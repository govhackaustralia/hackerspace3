class RenameApproval < ActiveRecord::Migration[5.2]
  def change
    rename_column :events, :approval, :published
    change_column_default :events, :published, false
  end
end
