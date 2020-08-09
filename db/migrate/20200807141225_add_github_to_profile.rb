class AddGithubToProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :github, :string
  end
end
