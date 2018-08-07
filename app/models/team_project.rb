class TeamProject < ApplicationRecord
  has_many :assignments, as: :assignable
  belongs_to :event
  has_one :team_project_version
  has_many :team_project_versions, inverse_of: :team_project, dependent: :destroy
  accepts_nested_attributes_for :team_project_versions, reject_if: proc { |attributes| attributes['team_name'].blank? }

  after_create :after_create_check

  def after_create_check
    team_project_versions.create(team_name: "Team #{id}") if current_version.nil?
    current_version.update(team_name: "Team #{id}") if current_version.team_name.blank?
  end

  def team_leader
    assignment = Assignment.find_by(assignable_type: 'TeamProject', assignable_id: id, title: TEAM_LEADER)
    return if assignment.nil?
    assignment.user
  end

  def assign_leader(user)
    assignments.create(title: TEAM_LEADER, user: user)
  end

  def team_members
    ids = assignments.where(title: TEAM_MEMBER).pluck(:user_id)
    return if ids.empty?
    User.where(id: ids)
  end

  def current_version
    return team_project_version unless team_project_version.nil?
    TeamProjectVersion.where(team_project: self).order(created_at: :asc).first
  end

  def change_event(event)
    update(event: event)
  end
end
