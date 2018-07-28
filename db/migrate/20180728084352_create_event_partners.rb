class CreateEventPartners < ActiveRecord::Migration[5.2]
  def change
    rename_table :event_parters, :event_partners
  end
end
