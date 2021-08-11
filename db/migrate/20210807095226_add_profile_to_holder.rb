class AddProfileToHolder < ActiveRecord::Migration[6.1]
  def change
    add_reference :holders, :profile, foreign_key: true

    Holder.all.preload(user: :profile).each do |holder|
      profile = holder.user.profile
      profile ||= Profile.find_or_create_by!(user: holder.user)
      holder.update! profile: profile
    end
  end
end
