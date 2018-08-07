class TeamProject < ApplicationRecord
  has_many :assignments, as: :assignable
  has_one :event

  def team_captain
    Assignment.find_by(assignable_type: 'TeamProject', assignable_id: id, title: TEAM_CAPTAIN)
  end

  def team_members
    assignments.where(title: TEAM_MEMBER)
  end
end
