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
end
