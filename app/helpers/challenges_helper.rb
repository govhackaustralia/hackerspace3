module ChallengesHelper
  def filter_challenges(challenges, term)
    return challenges if term.nil?
    @filtered_challenges = []
    @challenges.each { |challenge| search_challenge_string(challenge, term) }
    @filtered_challenges
  end

  def search_challenge_string(challenge, term)
    challenge_string = "#{challenge.name} #{challenge.short_desc}" \
                       "#{challenge.eligibility}" +
                       @id_regions[challenge.region_id].name.to_s.downcase
    @filtered_challenges << challenge if challenge_string.include? term.downcase
  end

  def challenge_teams(checkpoint)
    team_ids = checkpoint.entries.where(challenge: @challenge).pluck(:team_id)
    Team.where(id: team_ids)
  end

  def passed_competition_checkpoints
    passed_checkpoints = []
    @checkpoints.each do |checkpoint|
      comp_time = Time.now.in_time_zone(LAST_TIME_ZONE).to_formatted_s(:number)
      next if checkpoint.end_time.to_formatted_s(:number) > comp_time
      passed_checkpoints << checkpoint
    end
    passed_checkpoints
  end
end
