class AddPlaceId < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :place_id, :string
  end
end
