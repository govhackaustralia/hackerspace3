class AddTeamFormTimes < ActiveRecord::Migration[5.2]
  def change
    add_column :competitions, :team_form_start, :datetime
    add_column :competitions, :team_form_end, :datetime
    Competition.all.each do |competition|
      competition.update!(
        team_form_start: competition.start_time,
        team_form_end: competition.end_time
      )
    end
  end
end
