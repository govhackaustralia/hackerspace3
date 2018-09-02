class Stage3 < ActiveRecord::Migration[5.2]
  def change
    add_column :competitions, :start_time, :datetime
    add_column :competitions, :end_time, :datetime

    add_column :checkpoints, :max_regional_challenges, :integer
    add_column :checkpoints, :max_national_challenges, :integer
    
    add_column :checkpoints, :name, :string

    add_column :projects, :user_id, :integer

    add_column :teams, :published, :boolean, default: false

    change_column :challenges, :approved, :boolean, :default => false
  end
end
