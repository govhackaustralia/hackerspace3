class CreateAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :assignments do |t|
      t.integer :user_id
      t.string :assignable_type
      t.integer :assignable_id
      t.string :title
      t.timestamps
    end
  end
end
