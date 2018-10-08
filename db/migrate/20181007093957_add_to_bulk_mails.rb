class AddToBulkMails < ActiveRecord::Migration[5.2]
  def change
    add_column :bulk_mails, :from_email, :string
    add_column :bulk_mails, :subject, :string
  end
end
