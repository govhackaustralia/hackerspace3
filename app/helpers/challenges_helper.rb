module ChallengesHelper
  def challenge_entry_counts
    entries = Entry.where(challenge_id: @challenges.pluck(:id))
    @challenge_id_to_entry_count = {}
    @challenges.each { |challenge| @challenge_id_to_entry_count[challenge.id] = 0 }
    entries.each { |entry| @challenge_id_to_entry_count[entry.challenge_id] += 1 }
  end
end
