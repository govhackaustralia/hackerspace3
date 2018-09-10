class Assignment < ApplicationRecord
  belongs_to :assignable, polymorphic: true
  belongs_to :user
  has_many :registrations, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :teams, through: :favourites

  validates :title, inclusion: { in: VALID_ASSIGNMENT_TITLES }

  validate :can_only_join_team_if_registered_for_a_competition_event

  after_save :only_one_team_leader

  def only_one_team_leader
    return unless title == TEAM_LEADER
    leader_assignments = Assignment.where(assignable: assignable, title: TEAM_LEADER).order(updated_at: :asc)
    return unless leader_assignments.count > 1
    leader_assignments.first.update(title: TEAM_MEMBER)
  end

  def can_only_join_team_if_registered_for_a_competition_event
    return unless [TEAM_MEMBER, TEAM_LEADER, INVITEE].include? title
    registration_event_ids = user.registrations.where(status: [ATTENDING, WAITLIST]).pluck(:event_id)
    competition_event_ids = Competition.current.events.where(event_type: COMPETITION_EVENT).pluck(:id)
    if (registration_event_ids & competition_event_ids).empty?
      errors.add(:checkpoint_id, 'Register for a competition event to join or create a team.')
    end
  end
end
