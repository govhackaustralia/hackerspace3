class Team < ApplicationRecord
  has_many :assignments, as: :assignable
  belongs_to :event
  has_many :projects, dependent: :destroy
  has_many :team_data_sets, dependent: :destroy
  has_many :entries, dependent: :destroy

  def team_leader
    assignment = Assignment.find_by(assignable_type: 'Team', assignable_id: id, title: TEAM_LEADER)
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

  def invitees
    ids = assignments.where(title: INVITEE).pluck(:user_id)
    return if ids.empty?
    User.where(id: ids)
  end

  def current_project
    return Project.find(project_id) unless project_id.nil?
    projects.order(created_at: :desc).first
  end

  def change_event(event)
    update(event: event)
  end

  def name
    current_project.team_name
  end
end
