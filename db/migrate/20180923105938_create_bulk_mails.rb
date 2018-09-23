class CreateBulkMails < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_mails do |t|
      t.integer :region_id
      t.integer :user_id
      t.text :body

      t.timestamps
    end

    add_index :bulk_mails, :region_id
    add_index :bulk_mails, :user_id
  end
end
