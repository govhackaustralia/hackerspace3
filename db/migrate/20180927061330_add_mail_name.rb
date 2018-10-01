class AddMailName < ActiveRecord::Migration[5.2]
  def change
    add_column :bulk_mails, :name, :string
  end
end
