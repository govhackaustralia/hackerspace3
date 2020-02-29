class RemoveDefaultFalseFromUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :accepted_terms_and_conditions, from: false, to: nil
  end
end
