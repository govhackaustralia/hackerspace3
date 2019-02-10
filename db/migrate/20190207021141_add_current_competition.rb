class AddCurrentCompetition < ActiveRecord::Migration[5.2]
  def change
    add_column :competitions, :current, :boolean
    add_index :competitions, :current

    comp = Competition.first
    return if comp.nil?
    comp.update current: true
  end
end
