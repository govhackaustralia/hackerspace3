class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.integer :assignment_id
      t.datetime :time_notified
      t.string :status

      t.timestamps
    end
  end
end
