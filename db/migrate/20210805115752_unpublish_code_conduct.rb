class UnpublishCodeConduct < ActiveRecord::Migration[6.1]
  def change
    User.joins(:profile).where(accepted_code_of_conduct: nil, profiles: {published: true}).preload(:profile).each do |user|
      user.profile.update! published: false
    end
  end
end
