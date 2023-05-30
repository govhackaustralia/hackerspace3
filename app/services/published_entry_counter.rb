# frozen_string_literal: true

class PublishedEntryCounter
  attr_reader :competition, :challenge, :challenge_ids

  def initialize(competition, challenge_ids: [])
    @competition = competition
    @challenge_ids = challenge_ids
  end

  def count(challenge)
    @challenge = challenge
    challenge_entries.count do |entry|
      region_passed_checkpoints.include? entry.checkpoint_id
    end
  end

  private

  def challenge_entries
    challenges.detect { |c| c == challenge }.published_entries
  end

  def challenges
    @challenges ||= if challenge_ids.any?
      competition.challenges.where(id: challenge_ids).preload :published_entries
    else
      competition.challenges.preload :published_entries
    end
  end

  def region_passed_checkpoints
    compute_region_passed_checkpoints unless @region_passed_checkpoints.is_a? Hash
    @region_passed_checkpoints[challenge.region_id]
  end

  def compute_region_passed_checkpoints
    @region_passed_checkpoints = {}
    competition.regions.each do |region|
      @region_passed_checkpoints[region.id] = competition.passed_checkpoint_ids(
        region.time_zone,
      )
    end
  end
end
