module ChallengesHelper
  def user_challenges_path
    return table_challenges_path if cookies[:challenge_index_view] == 'table'

    challenges_path
  end
end
