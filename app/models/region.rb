class Region < ApplicationRecord
  has_many :assignments, as: :assignable
  has_many :events
  has_many :sponsorships, as: :sponsorable
  has_many :sponsorship_types, through: :sponsorships

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
    supports = []
    assignments.where(title: REGION_SUPPORT).each do |assignment|
      supports << assignment.user
    end
    supports
  end

  # Will retrieve all assignments up through to the root region.
  def admin_assignments(collected = [])
    collected << assignments.where(title: REGION_ADMIN).to_a
    return collected.flatten if parent_id.nil?
    parent.admin_assignments(collected)
  end
end
