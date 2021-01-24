module TeamsHelper
  def team_thumbnail_asset_path(team)
    return url_for(team.thumbnail) if team.thumbnail.attached?

    'default_profile_pic.png'
  end
end
