class CreateEntries < ActiveRecord::Migration[5.2]
  def change
      rename_table :submissions, :entries
  end
end
