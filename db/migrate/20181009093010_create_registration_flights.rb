class CreateRegistrationFlights < ActiveRecord::Migration[5.2]
  def change
    create_table :registration_flights do |t|
      t.integer :registration_id
      t.integer :flight_id

      t.timestamps
    end
  end
end
