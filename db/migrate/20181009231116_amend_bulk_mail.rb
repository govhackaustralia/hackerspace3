class AmendBulkMail < ActiveRecord::Migration[5.2]
  def change
    # Make Bulk Mails Polymorphic

    remove_index :bulk_mails, name: :index_bulk_mails_on_region_id
    remove_column :bulk_mails, :region_id, :integer

    add_column :bulk_mails, :mailable_type, :string
    add_column :bulk_mails, :mailable_id, :integer
    add_index :bulk_mails, [:mailable_type, :mailable_id]

    # Replace MailOrder with TeamOrder and UserOrder

    drop_table :mail_orders

    create_table :team_orders do |t|
      t.integer :bulk_mail_id
      t.integer :team_id
      t.string :request_type

      t.timestamps
    end

    add_index :team_orders, :bulk_mail_id
    add_index :team_orders, :team_id
    add_index :team_orders, :request_type

    create_table :user_orders do |t|
      t.integer :bulk_mail_id
      t.string :request_type

      t.timestamps
    end

    add_index :user_orders, :bulk_mail_id
    add_index :user_orders, :request_type

    # Make Correspondence Polymorphic

    remove_index :correspondences, name: :index_correspondences_on_mail_order_id
    remove_column :correspondences, :mail_order_id, :integer

    add_column :correspondences, :orderable_type, :string
    add_column :correspondences, :orderable_id, :integer
    add_index :correspondences, [:orderable_type, :orderable_id]
  end
end
