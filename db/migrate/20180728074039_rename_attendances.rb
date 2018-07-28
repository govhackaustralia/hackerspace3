class RenameRegistrations < ActiveRecord::Migration[5.2]
  def change
    rename_table :attendances, :registrations
  end
end
