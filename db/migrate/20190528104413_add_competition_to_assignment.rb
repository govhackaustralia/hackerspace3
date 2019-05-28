class AddCompetitionToAssignment < ActiveRecord::Migration[5.2]
  def change
    add_column :assignments, :competition_id, :integer
    add_index :assignments, :competition_id
    Competition.all.each do |comp|
      comp.assignments.update_all competition_id: comp.id
    end
    [Sponsor, Region, Challenge, Event, Team].each do |model|
      model.all.each do |instance|
        instance.assignments.update_all competition_id: instance.competition.id
      end
    end
  end
end
