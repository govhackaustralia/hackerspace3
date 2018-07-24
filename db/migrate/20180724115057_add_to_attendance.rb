class AddToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :event_id, :integer
  end
end
