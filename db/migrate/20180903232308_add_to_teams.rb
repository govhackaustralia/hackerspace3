class AddToTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :youth_team, :boolean, default: false
    add_column :challenge_sponsorships, :approved, :boolean, default: false
  end
end
