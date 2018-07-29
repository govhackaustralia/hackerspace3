class AddAcceptedTermAndConditions < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :accepted_term_and_conditions, :boolean, default: false
  end
end
