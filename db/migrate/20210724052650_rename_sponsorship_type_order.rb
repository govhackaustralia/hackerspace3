class RenameSponsorshipTypeOrder < ActiveRecord::Migration[6.1]
  def change
    rename_column :sponsorship_types, :order, :position
  end
end
