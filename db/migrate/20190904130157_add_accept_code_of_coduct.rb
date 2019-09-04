class AddAcceptCodeOfCoduct < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :accepted_code_of_conduct, :datetime
  end
end
