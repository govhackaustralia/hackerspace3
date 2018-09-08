class Region < ApplicationRecord
  has_many :assignments, as: :assignable, dependent: :destroy
  has_many :events
  has_many :teams, through: :events
  has_many :entries, through: :teams
  has_many :sponsorships, as: :sponsorable, dependent: :destroy
  has_many :sponsorship_types, through: :sponsorships
  has_many :challenges, dependent: :destroy
  has_many :data_sets, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true

  # Note 'nil' added to VALID_TIME_ZONES so that a region does not require a
  # time_zone; eg Australia.
  validates :time_zone, inclusion: { in: VALID_TIME_ZONES << nil }

  def sub_regions
    Region.where(parent_id: id)
  end

  def parent
    Region.where(id: parent_id).first
  end

  def self.root
    Region.find_or_create_by(parent_id: nil, name: ROOT_REGION_NAME)
  end

  def parent_root?
    return true if Region.root == parent
  end

  def director
    assignment = assignments.where(title: REGION_DIRECTOR).first
    return assignment if assignment.nil?
    assignment.user
  end

  def supports
    user_ids = assignments.where(title: REGION_SUPPORT).pluck(:user_id)
    return nil if user_ids.empty?
    User.where(id: user_ids)
  end

  def admin_privileges?(user)
    (admin_assignments & user.assignments).present?
  end

  # Will retrieve all assignments up through to the root region.
  def admin_assignments(collected = [])
    collected << assignments.where(title: REGION_ADMIN).to_a
    collected << Competition.current.admin_assignments
    return collected.flatten if parent_id.nil?
    parent.admin_assignments(collected).flatten
  end

  def national?
    parent_id.nil?
  end

  def self.national_challenges_region_counts(checkpoint_ids = nil)
    challenge_to_region_array = {}
    regions = Region.where.not(parent_id: nil)
    region_to_entries = {}
    regions.each do |region|
      region_to_entries[region] = if checkpoint_ids.nil?
                                    region.entries
                                  else
                                    region.entries.where(checkpoint_id: checkpoint_ids)
                                  end
    end

    Region.root.challenges.each do |challenge|
      challenge_entries = challenge.entries
      challenge_to_region_array[challenge.name] = {}
      regions.each do |region|
        entry_count = (challenge_entries & region_to_entries[region]).count
        challenge_to_region_array[challenge.name][region.name] = entry_count
      end
    end
    challenge_to_region_array
  end

  def regional_challenges_event_counts(checkpoint_ids = nil)
    challenge_to_event_array = {}
    events = Competition.current.events.where(region: self, event_type: COMPETITION_EVENT)
    event_to_entries = {}
    events.each do |event|
      event_to_entries[event] = if checkpoint_ids.nil?
                                    event.entries
                                  else
                                    event.entries.where(checkpoint_id: checkpoint_ids)
                                  end
    end

    challenges.each do |challenge|
      challenge_entries = challenge.entries
      challenge_to_event_array[challenge.name] = {}
      events.each do |event|
        entry_count = (challenge_entries & event_to_entries[event]).count
        challenge_to_event_array[challenge.name][event.name] = entry_count
      end
    end
    challenge_to_event_array
  end

  def self.id_regions(regions)
    regions = where(id: regions.uniq) if regions.class == Array
    id_regions = {}
    regions.each { |region| id_regions[region.id] = region }
    id_regions
  end
end
