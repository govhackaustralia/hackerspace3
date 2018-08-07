class TeamProject < ApplicationRecord
  has_many :assignments, as: :assignable
  belongs_to :event
  has_one :team_project_version

  def team_captain
    Assignment.find_by(assignable_type: 'TeamProject', assignable_id: id, title: TEAM_CAPTAIN)
  end

  def team_members
    assignments.where(title: TEAM_MEMBER)
  end

  def current_version
    return team_project_version unless team_project_version.nil?
    TeamProjectVersion.where(team_project: self).order(created_at: :asc).first
  end

  def change_event(event)
    update(event: event)
  end
end
