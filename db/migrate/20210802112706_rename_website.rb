class RenameWebsite < ActiveRecord::Migration[6.1]
  def change
    rename_column :sponsors, :website, :url
  end
end
