class Competition < ApplicationRecord
  has_many :assignments, as: :assignable
  has_many :events

  validates :year, presence: true

  def self.current
    find_or_create_by(year: Time.current.year)
  end

  def director
    assignment = assignments.where(title: COMPETITION_DIRECTOR).first
    return assignment if assignment.nil?
    assignment.user
  end

  def sponsorship_director
    assignment = assignments.where(title: SPONSORSHIP_DIRECTOR).first
    return assignment if assignment.nil?
    assignment.user
  end

  def management_team
    assignments.where(title: MANAGEMENT_TEAM)
  end

  def volunteers
    assignments.where(title: VOLUNTEER)
  end

  def site_admin
    assignments.where(title: ADMIN)
  end

  def admin_assignments
    assignments.where(title: COMP_ADMIN).to_a
  end
end
