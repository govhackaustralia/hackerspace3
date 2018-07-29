class AmendAcceptedTermAndConditions < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :accepted_term_and_conditions, :accepted_terms_and_conditions
  end
end
