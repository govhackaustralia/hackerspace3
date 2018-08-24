class AddColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :competitions, :start_time, :datetime
    add_column :competitions, :end_time, :datetime

    add_column :checkpoints, :max_regional_challenges, :integer
    add_column :checkpoints, :max_national_challenges, :integer
  end
end
