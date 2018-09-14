class AddChallengeIdentifier < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :identifier, :string
    add_index :challenges, :identifier
  end
end
