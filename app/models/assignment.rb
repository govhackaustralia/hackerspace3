class Assignment < ApplicationRecord
  belongs_to :assignable, polymorphic: true
  belongs_to :user
  has_many :registrations, dependent: :destroy
  has_many :challenge_scorecards, dependent: :destroy
  has_many :peoples_scorecards, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :teams, through: :favourites

  validates :title, inclusion: { in: VALID_ASSIGNMENT_TITLES }

  after_save :only_one_team_leader

  def only_one_team_leader
    return unless title == TEAM_LEADER
    leader_assignments = Assignment.where(assignable: assignable, title: TEAM_LEADER).order(updated_at: :asc)
    return unless leader_assignments.count > 1
    leader_assignments.first.update(title: TEAM_MEMBER)
  end
end
