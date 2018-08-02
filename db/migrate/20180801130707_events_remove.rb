class EventsRemove < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :category_type, :string
  end
end
