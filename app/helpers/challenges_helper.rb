module ChallengesHelper
  def challenge_teams(checkpoint)
    team_ids = checkpoint.entries.where(challenge: @challenge).pluck(:team_id)
    Team.where(id: team_ids, published: true).preload(:current_project)
  end
end
