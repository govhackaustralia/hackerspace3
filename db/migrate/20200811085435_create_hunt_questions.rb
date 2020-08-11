class CreateHuntQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :hunt_questions do |t|
      t.integer :competition_id
      t.string :question
      t.string :answer

      t.timestamps
    end
  end
end
