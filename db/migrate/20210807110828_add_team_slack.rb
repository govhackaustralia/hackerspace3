class AddTeamSlack < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :slack_channel_id, :string
  end
end
