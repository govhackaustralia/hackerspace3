class AddProfileAttributes < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :team_status, :integer
    add_column :profiles, :website, :string
    add_column :profiles, :linkedin, :string
    add_column :profiles, :twitter, :string
    add_column :profiles, :description, :string

    User.where.not(twitter: nil).each do |user|
      profile = Profile.find_or_initialize_by user: user
      profile.twitter = user.twitter
      profile.save
    end

    raise 'something went wrong' if User.where.not(twitter: nil).count !=
                                    Profile.where.not(twitter: nil).count

    remove_column :users, :twitter, :string
  end
end
