class Region < ApplicationRecord
  # Australian/New Zealand Time Zones
  VALID_TIME_ZONES =
    ActiveSupport::TimeZone.country_zones('AU') +
    ActiveSupport::TimeZone.country_zones('NZ')

  attr_reader :valid_time_zones

  belongs_to :parent, class_name: 'Region', optional: true
  belongs_to :competition

  has_many :sub_regions, class_name: 'Region', foreign_key: 'parent_id'
  has_many :assignments, as: :assignable, dependent: :destroy
  has_many :events
  has_many :teams, through: :events
  has_many :published_projects_by_name, through: :events
  has_many :entries, through: :teams
  has_many :sponsorships, as: :sponsorable, dependent: :destroy
  has_many :sponsorship_types, through: :sponsorships
  has_many :challenges, dependent: :destroy
  has_many :data_sets, dependent: :destroy
  has_many :bulk_mails, as: :mailable, dependent: :destroy
  has_many :support_assignments, -> { region_supports }, class_name: 'Assignment', as: :assignable
  has_many :supports, through: :support_assignments, source: :user

  scope :subs, -> { where.not parent_id: nil }
  scope :roots, -> { where parent_id: nil }

  validates :name, uniqueness: {
    scope: :competition_id,
    message: 'Region name already taken in this competition'
  }

  validate :only_one_root_per_competition

  validates :time_zone, allow_nil: true, inclusion: {
    in: VALID_TIME_ZONES.map(&:name)
  }

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

  # Returns a boolean whether a region is the national/root region.
  def root?
    parent_id.nil?
  end

  # Returns a boolean for whether the awards for a region have been released or
  # not.
  def awards_released?
    return false if award_release.nil?

    award_release.to_formatted_s(:number) < Time.now.in_time_zone(COMP_TIME_ZONE).to_formatted_s(:number)
  end

  # Ensures only one root region is assigned to a competition
  def only_one_root_per_competition
    return unless parent_id.nil?

    roots = competition.regions.roots
    return unless roots.exclude?(self) && roots.count.positive?

    errors.add :competition, 'Only one root region per competition.'
  end
end
