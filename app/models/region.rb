# frozen_string_literal: true

# == Schema Information
#
# Table name: regions
#
#  id             :bigint           not null, primary key
#  award_release  :datetime
#  category       :string
#  identifier     :string
#  name           :string
#  time_zone      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  competition_id :integer
#  parent_id      :integer
#
# Indexes
#
#  index_regions_on_competition_id  (competition_id)
#  index_regions_on_identifier      (identifier)
#  index_regions_on_parent_id       (parent_id)
#
class Region < ApplicationRecord
  # Region Categories
  INTERNATIONAL = 'International'
  NATIONAL = 'National'
  REGIONAL = 'Regional'

  CATEGORIES = [INTERNATIONAL, NATIONAL, REGIONAL].freeze

  # Australian/New Zealand Time Zones
  VALID_TIME_ZONES =
    ActiveSupport::TimeZone.country_zones('AU') +
    ActiveSupport::TimeZone.country_zones('NZ')

  attr_reader :valid_time_zones

  belongs_to :parent, class_name: 'Region', optional: true
  belongs_to :competition

  has_many :sub_regions, class_name: 'Region', foreign_key: 'parent_id'
  has_many :sub_region_teams, through: :sub_regions, source: :teams
  has_many :sub_region_challenges, through: :sub_regions, source: :challenges
  has_many :assignments, as: :assignable, dependent: :destroy
  has_many :events
  has_many :teams, through: :events
  has_many :published_projects_by_name, through: :events
  has_many :entries, through: :teams
  has_many :sponsorships, as: :sponsorable, dependent: :destroy
  has_many :sponsorship_types, through: :sponsorships
  has_many :challenges, dependent: :destroy
  has_many :approved_challenges, -> { approved.order(name: :asc) }, class_name: 'Challenge'
  has_many :data_sets, dependent: :destroy
  has_many :support_assignments, -> { region_supports }, class_name: 'Assignment', as: :assignable
  has_many :supports, through: :support_assignments, source: :user
  has_many :region_limits

  scope :regionals, -> { where category: REGIONAL }
  scope :nationals, -> { where category: NATIONAL }
  scope :internationals, -> { where category: INTERNATIONAL }
  scope :lows, -> { where category: [NATIONAL, REGIONAL] }
  scope :highs, -> { where category: [NATIONAL, INTERNATIONAL] }

  validates :name, uniqueness: {
    scope: :competition_id,
    message: 'Region name already taken in this competition',
  }

  validates :category, inclusion: {in: CATEGORIES}

  validate :only_one_international_per_competition,
    :only_international_can_be_parent_of_national,
    :only_national_can_be_parent_of_regional,
    :only_non_descendants_can_be_parents

  validates :time_zone, allow_blank: true, inclusion: {
    in: VALID_TIME_ZONES.map(&:name),
  }

  after_save_commit :update_identifier

  def to_param
    identifier
  end

  # Returns the user record for the Director of a region.
  # ENHANCEMENT: Move into active record associations.
  def director
    assignment = assignments.where(title: REGION_DIRECTOR).first
    return assignment if assignment.nil?

    assignment.user
  end

  # Returns a boolean for whether a user as admin privileges for a region.
  def admin_privileges?(user)
    (admin_assignments & user.assignments).present?
  end

  # Will retrieve all assignments up through to the root region.
  def admin_assignments(collected = [])
    collected << assignments.where(title: REGION_ADMIN).to_a
    collected << competition.admin_assignments
    return collected.flatten if parent_id.nil?

    parent.admin_assignments(collected).flatten
  end

  # Returns a true if a region is the international region, false otherwise
  def international?
    category == INTERNATIONAL
  end

  # Returns a true if a region is a national region, false otherwise
  def national?
    category == NATIONAL
  end

  # Returns a true if a region is a regional region, false otherwise
  def regional?
    category == REGIONAL
  end

  # Returns a boolean for whether the awards for a region have been released or
  # not.
  def awards_released?
    return false if award_release.nil?

    award_release.to_formatted_s(:number) < Time.now.in_time_zone(LAST_COMPETITION_TIME_ZONE).to_formatted_s(:number)
  end

  # Returns a custom region checkpoint challenge limit either of this region
  # or of a parent, nil if no such region limit exists
  def limit(checkpoint)
    region_limits.find_by(checkpoint: checkpoint) || parent&.limit(checkpoint)
  end

  # Returns teams registered to events in a region or any children regions.
  def competing_teams
    return competition.teams if international?

    teams.presence || sub_region_teams
  end

  # Return an array of the challenges a team 'under' the region can enter
  def eligible_challenges
    [
      challenges +
        sub_region_challenges.nation_wides +
        [parent&.eligible_challenges]
    ].flatten.uniq.compact
  end

  # Returns the time in a particular region.
  def time
    self.class.region_time(time_zone)
  end

  def self.region_time(time_zone = nil)
    Time.now.in_time_zone(
      time_zone.presence || LAST_COMPETITION_TIME_ZONE
    ).to_formatted_s(:number)
  end

  def zone_code_when(time)
    time.in_time_zone(time_zone.presence || LAST_COMPETITION_TIME_ZONE).zone
  end

  private

  # Ensures only one root region is assigned to a competition
  def only_one_international_per_competition
    return unless parent_id.nil?

    internationals = competition.regions.internationals
    return unless internationals.exclude?(self) && internationals.count.positive?

    errors.add :competition, 'Only one international region per competition'
  end

  def only_international_can_be_parent_of_national
    return if [category, parent_id].include? nil

    return unless national?

    return if parent.international?

    errors.add :parent, 'Only root can be parent of national'
  end

  def only_national_can_be_parent_of_regional
    return if [category, parent_id].include? nil

    return unless regional?

    return if parent.national?

    errors.add :parent, 'Only national can be parent of regional'
  end

  def only_non_descendants_can_be_parents
    current = self
    loop do
      break if (current = current.parent).nil?
      break errors.add(:parent, 'already a descendant region') if self == current
    end
  end

  # Generates a unique name and updates the identifier field.
  def update_identifier
    update_columns identifier: uri_pritty(name)
  end
end
