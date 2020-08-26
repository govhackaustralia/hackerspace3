class ActOnBehalfOf < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :acting_on_behalf_of_id, :integer
  end
end
