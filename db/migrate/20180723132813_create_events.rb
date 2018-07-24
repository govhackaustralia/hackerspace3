class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer   :region_id
      t.integer   :competition_id
      t.string    :name
      t.string    :registration_type
      t.integer   :capacity
      t.string    :email
      t.string    :twitter
      t.text      :address
      t.text      :accessibility
      t.text      :youth_support
      t.text      :parking
      t.text      :public_transport
      t.text      :operation_hours
      t.text      :catering
      t.decimal   :lat, { precision: 10, scale: 6}
      t.decimal   :long, { precision: 10, scale: 6}
      t.string    :video_url
      t.datetime  :start_time
      t.datetime  :end_time
      t.boolean   :approval

      t.timestamps
    end
  end
end
