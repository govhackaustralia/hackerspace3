class PublishForHuntQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :competitions, :hunt_published, :boolean
  end
end
