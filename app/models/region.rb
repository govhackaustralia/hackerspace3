class Region < ApplicationRecord
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
end
