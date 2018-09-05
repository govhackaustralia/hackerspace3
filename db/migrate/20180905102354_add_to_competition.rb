class AddToCompetition < ActiveRecord::Migration[5.2]
  def change
    add_column :competitions, :peoples_choice_start, :datetime
    add_column :competitions, :peoples_choice_end, :datetime
    add_column :competitions, :challenge_judging_start, :datetime
    add_column :competitions, :challenge_judging_end, :datetime
  end
end
