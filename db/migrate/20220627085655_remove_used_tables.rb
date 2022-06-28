class RemoveUsedTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :correspondences
    drop_table :bulk_mails
    drop_table :flights
    drop_table :registration_flights
    drop_table :team_orders
    drop_table :user_orders
  end
end
