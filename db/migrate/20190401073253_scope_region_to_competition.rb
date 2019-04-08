class ScopeRegionToCompetition < ActiveRecord::Migration[5.2]
  def up
    add_column :regions, :competition_id, :integer
    add_index :regions, :competition_id
    competition_id = Competition.first.id
    Region.update_all competition_id: competition_id
    remove_column :events, :competition_id, :integer
    remove_column :data_sets, :competition_id, :integer
    remove_column :challenges, :competition_id, :integer
  end

  def down
    add_column :events, :competition_id, :integer
    add_column :data_sets, :competition_id, :integer
    add_column :challenges, :competition_id, :integer

    add_index :events, :competition_id
    add_index :data_sets, :competition_id
    add_index :challenges, :competition_id

    competition_id = Competition.first.id
    Event.update_all competition_id: competition_id
    DataSet.update_all competition_id: competition_id
    Challenge.update_all competition_id: competition_id

    remove_column :regions, :competition_id, :integer
  end
end
