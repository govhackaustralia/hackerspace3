# frozen_string_literal: true

module ChallengesHelper
  def user_challenges_path
    return table_challenges_path if cookies[:challenge_index_view] == 'table'

    challenges_path
  end

  def sponsor_logo_asset_path(sponsor)
    return url_for(sponsor.logo) if sponsor.logo.attached?

    'default_profile_pic.png'
  end
end
