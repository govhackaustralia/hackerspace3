module ProfilesHelper
  def default_profile_picture_url(user, profile)
    if profile.present? && profile.profile_picture.attached?
      url_for profile.profile_picture
    elsif user.google_img.present?
      user.google_img
    else
      user.gravatar_url
    end
  end

  def profile_slack_chat_url(profile)
    "slack://user?team=#{ENV['SLACK_TEAM_ID']}&id=#{profile.slack_user_id}"
  end
end
