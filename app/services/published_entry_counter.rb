class PublishedEntryCounter
  def initialize(competition)
    @challenges = competition.challenges.preload :published_entries
    @region_to_passed = {}
    competition.regions.each do |region|
      @region_to_passed[region.id] = competition.passed_checkpoint_ids(
        region.time_zone
      )
    end
  end

  def count(challenge)
    passed_entries = []
    checkpoint_ids = @region_to_passed[challenge.region_id]
    challenge_entries(challenge).each do |entry|
      passed_entries << entry if checkpoint_ids.include? entry.checkpoint_id
    end
    passed_entries.length
  end

  private

  def challenge_entries(challenge)
    @challenges.each do |c|
      next unless c == challenge

      return c.published_entries
    end
  end
end
