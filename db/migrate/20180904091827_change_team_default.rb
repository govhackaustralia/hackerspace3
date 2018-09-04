class ChangeTeamDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :teams, :published, true
  end
end
