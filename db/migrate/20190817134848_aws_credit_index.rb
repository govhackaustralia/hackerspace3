class AwsCreditIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :aws_credits_requested
  end
end
