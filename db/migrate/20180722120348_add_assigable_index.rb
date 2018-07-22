class AddAssigableIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :assignments, [:assignable_type, :assignable_id]
  end
end
