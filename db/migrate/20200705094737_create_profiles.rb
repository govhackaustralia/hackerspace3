class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.integer :age
      t.string :gender
      t.integer :first_peoples
      t.integer :disability
      t.integer :education
      t.integer :employment
      t.string :users, :postcode

      t.timestamps
    end

    add_column :holders, :team_status, :integer
    add_index :holders, :team_status

    add_column :users, :under_18, :boolean
    add_index :users, :under_18

    add_column :users, :region, :integer
    add_index :users, :region
  end
end
