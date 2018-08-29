module ChallengesHelper
  def challenge_entry_counts
    entries = Entry.where(challenge_id: @challenges.pluck(:id))
    @challenge_id_to_entry_count = {}
    @challenges.each { |challenge| @challenge_id_to_entry_count[challenge.id] = 0 }
    entries.each { |entry| @challenge_id_to_entry_count[entry.challenge_id] += 1 }
  end

  def filter_challenges(challenges, term)
    retrieve_region_names
    return challenges if term.nil?
    @filtered_challenges = []
    @challenges.each { |challenge| search_challenge_string(challenge , term) }
    @filtered_challenges
  end

  def search_challenge_string(challenge, term)
    challenge_string = "#{challenge.name} #{challenge.short_desc}" +
    "#{challenge.long_desc} #{challenge.eligibility}" +
    "#{@region_id_to_region_name[challenge.region_id]}".downcase
    @filtered_challenges << challenge if challenge_string.include? term.downcase
  end

  def retrieve_region_names
    @region_id_to_region_name = {}
    Region.all.each do |region|
      @region_id_to_region_name[region.id] = region.name
    end
  end
end
