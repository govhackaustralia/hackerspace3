class AddAws < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :aws_credits_requested, :boolean
  end
end
