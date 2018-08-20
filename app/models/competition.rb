class Competition < ApplicationRecord
  has_many :assignments, as: :assignable
  has_many :sponsors
  has_many :sponsorship_types
  has_many :events
  has_many :teams, through: :events
  has_many :challenges
  has_many :checkpoints
  has_many :data_sets

  validates :year, presence: true

  def assignment_privileges(_action, _access)
    assignments.where(title: [MANAGEMENT_TEAM, ADMIN, COMPETITION_DIRECTOR])
  end

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

  def site_admins
    assignment_user_ids = assignments.where(title: ADMIN).pluck(:user_id)
    return nil if assignment_user_ids.empty?
    User.where(id: assignment_user_ids)
  end

  def management_team
    assignment_user_ids = assignments.where(title: MANAGEMENT_TEAM).pluck(:user_id)
    return nil if assignment_user_ids.empty?
    User.where(id: assignment_user_ids)
  end

  def volunteers
    assignment_user_ids = assignments.where(title: VOLUNTEER).pluck(:user_id)
    return nil if assignment_user_ids.empty?
    User.where(id: assignment_user_ids)
  end

  def admin_assignments
    assignments.where(title: COMP_ADMIN).to_a
  end

  def events_on?(type)
    events.where(type: type).present?
  end
end
