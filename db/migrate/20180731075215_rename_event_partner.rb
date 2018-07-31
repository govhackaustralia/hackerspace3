class RenameEventPartner < ActiveRecord::Migration[5.2]
  def change
    rename_table :event_partners, :event_partnerships
  end
end
