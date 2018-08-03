class AddDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :full_name, false
    change_column_default :users, :full_name, from: nil, to: ''
  end
end
