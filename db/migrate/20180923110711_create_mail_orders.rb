class CreateMailOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :mail_orders do |t|
      t.integer :bulk_mail_id
      t.integer :team_id
      t.string :request_type

      t.timestamps
    end

    add_index :mail_orders, :bulk_mail_id
    add_index :mail_orders, :team_id
    add_index :mail_orders, :request_type
  end
end
