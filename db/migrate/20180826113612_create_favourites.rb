class CreateFavourites < ActiveRecord::Migration[5.2]
  def change
    create_table :favourites do |t|
      t.integer :assignment_id
      t.integer :team_id

      t.timestamps
    end
  end
end
