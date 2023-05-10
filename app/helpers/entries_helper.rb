# frozen_string_literal: true

module EntriesHelper
  def challenges_event_counts(region, checkpoint_ids = nil)
    events = region.events.competitions
    event_to_entries = populate_entity_to_entries(events, checkpoint_ids)
    unpublished_entries = Entry.where(team: region.teams.unpublished)
    challenges = region.challenges
    populate_challenge_to_entity(challenges, events, unpublished_entries, event_to_entries)
  end

  def challenges_region_counts(competition, checkpoint_ids = nil)
    regions = competition.regions.lows
    region_to_entries = populate_entity_to_entries(regions, checkpoint_ids)
    unpublished_entries = Entry.where(team: competition.teams.unpublished)
    challenges = competition.international_region.challenges
    populate_challenge_to_entity(challenges, regions, unpublished_entries, region_to_entries)
  end

  private

  def populate_entity_to_entries(entities, checkpoint_ids)
    entity_to_entries = {}
    entities.each do |entity|
      entity_to_entries[entity] = relevant_entries(checkpoint_ids, entity)
    end
    entity_to_entries
  end

  def relevant_entries(checkpoint_ids, entity)
    if checkpoint_ids.nil?
      entity.entries
    else
      entity.entries.where(checkpoint_id: checkpoint_ids)
    end
  end

  def populate_challenge_to_entity(challenges, entities, unpublished_entries, entity_to_entries)
    challenge_to_entity_array = {}
    challenges.each do |challenge|
      entry_count_challenge(challenge, entities, challenge_to_entity_array, unpublished_entries, entity_to_entries)
    end
    challenge_to_entity_array
  end

  def entry_count_challenge(challenge, entities, challenge_to_entity_array, unpublished_entries, entity_to_entries)
    challenge_entries = challenge.entries
    challenge_to_entity_array[challenge.name] = {}
    challenge_count = 0
    entities.each do |entity|
      challenge_count += entry_count_entity(challenge_entries, unpublished_entries, entity_to_entries, challenge_to_entity_array, challenge, entity)
    end
    challenge_to_entity_array[challenge.name][:total_entries] = challenge_count
  end

  def entry_count_entity(challenge_entries, unpublished_entries, entity_to_entries, challenge_to_entity_array, challenge, entity)
    entry_count = ((challenge_entries - unpublished_entries) & entity_to_entries[entity]).count
    challenge_to_entity_array[challenge.name][entity.name] = entry_count
  end
end
