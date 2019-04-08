class Region < ApplicationRecord
  belongs_to :parent, class_name: 'Region', optional: true

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

  scope :sub_regions, -> { where.not(parent_id: nil) }
  has_many :support_assignments, -> { region_supports }, class_name: 'Assignment', as: :assignable
  has_many :supports, through: :support_assignments, source: :user

  validates :name, presence: true, uniqueness: true

  # Note 'nil' added to VALID_TIME_ZONES so that a region does not require a
  # time_zone; eg Australia.
  validates :time_zone, inclusion: { in: VALID_TIME_ZONES << nil }

  # Retruns the root region.
  def self.root
    Region.find_or_create_by(parent_id: nil, name: ROOT_REGION_NAME)
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
    collected << Competition.current.admin_assignments
    return collected.flatten if parent_id.nil?

    parent.admin_assignments(collected).flatten
  end

  # Returns a boolean whether a region is the national/root region.
  def national?
    parent_id.nil?
  end

  # Returns a boolean for whether the awards for a region have been released or
  # not.
  def awards_released?
    return false if award_release.nil?

    award_release.to_formatted_s(:number) < Time.now.in_time_zone(COMP_TIME_ZONE).to_formatted_s(:number)
  end
end
