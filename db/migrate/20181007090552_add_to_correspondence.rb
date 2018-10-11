class AddToCorrespondence < ActiveRecord::Migration[5.2]
  def change
    add_column :correspondences, :body, :string
  end
end
