class SlackId < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :slack_user_id, :string
    add_column :profiles, :slack_access_token, :string
  end
end
