class Competition < ApplicationRecord
  has_many :assignments, as: :assignable
  has_many :sponsors
  has_many :sponsorship_types
  has_many :events
  has_many :connections

  validates :year, presence: true

  def self.current
    find_or_create_by(year: Time.current.year)
  end

  def director
    assignment = assignments.where(title: COMPETITION_DIRECTOR).first
    return nil if assignment.nil?
    assignment.user
  end

  def sponsorship_director
    assignment = assignments.where(title: SPONSORSHIP_DIRECTOR).first
    return nil if assignment.nil?
    assignment.user
  end

  def site_admin
    assignment = assignments.where(title: ADMIN).first
    return nil if assignment.nil?
    assignment.user
  end

  def management_team
    members = []
    assignments.where(title: MANAGEMENT_TEAM).each do |assignment|
      members << assignment.user
    end
    members
  end

  def volunteers
    members = []
    assignments.where(title: VOLUNTEER).each do |assignment|
      members << assignment.user
    end
    members
  end

  def admin_assignments
    assignments.where(title: COMP_ADMIN).to_a
  end

  def events_on?(type)
    events.where(type: type).present?
  end
end
