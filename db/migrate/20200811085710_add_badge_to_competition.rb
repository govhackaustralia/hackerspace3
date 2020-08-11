class AddBadgeToCompetition < ActiveRecord::Migration[6.0]
  def change
    add_column :competitions, :hunt_badge_id, :integer
  end
end
