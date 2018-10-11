class CreateCorrespondences < ActiveRecord::Migration[5.2]
  def change
    create_table :correspondences do |t|
      t.integer :mail_order_id
      t.integer :user_id
      t.string :status

      t.timestamps
    end

    add_index :correspondences, :mail_order_id
    add_index :correspondences, :user_id
    add_index :correspondences, :status
  end
end
