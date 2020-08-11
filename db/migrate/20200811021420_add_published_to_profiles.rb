class AddPublishedToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :published, :boolean
  end
end
