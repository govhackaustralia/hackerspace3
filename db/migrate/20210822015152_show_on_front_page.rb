class ShowOnFrontPage < ActiveRecord::Migration[6.1]
  def change
    add_column :resources, :show_on_front_page, :boolean
    add_index :resources, :show_on_front_page
  end
end
