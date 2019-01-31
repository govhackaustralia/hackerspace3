module ChallengesHelper
  # Returns all published teams entered into a a challenge at a particular
  # checkpoint.
  # ENHANCEMENT: DB queries made, this should be in the controller.
  def challenge_teams(checkpoint)
    team_ids = @challenge.entries_at(checkpoint).pluck(:team_id)
    Team.published.where(id: team_ids).preload(:current_project)
  end
end
