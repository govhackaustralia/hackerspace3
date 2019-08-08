class Assignment < ApplicationRecord
  belongs_to :assignable, polymorphic: true
  belongs_to :user
  belongs_to :competition

  has_many :registrations, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :favourite_teams, through: :favourites, source: :team
  has_many :scorecards, dependent: :destroy

  scope :event_assignments, -> { where title: EVENT_ASSIGNMENT_TITLES }
  scope :region_supports, -> { where title: REGION_SUPPORT }
  scope :event_hosts, -> { where title: EVENT_HOST }
  scope :event_supports, -> { where title: EVENT_SUPPORT }
  scope :participants, -> { where title: PARTICIPANT }
  scope :team_members, -> { where title: TEAM_MEMBER }
  scope :team_leaders, -> { where title: TEAM_LEADER }
  scope :team_invitees, -> { where title: INVITEE }
  scope :team_confirmed, -> { where title: [TEAM_LEADER, TEAM_MEMBER] }
  scope :team_participants, -> { where title: [TEAM_LEADER, TEAM_MEMBER, INVITEE] }
  scope :chief_judges, -> { where title: CHIEF_JUDGE }
  scope :judges, -> { where title: JUDGE }
  scope :staff, -> { where.not title: [PARTICIPANT, VIP, TEAM_LEADER, TEAM_MEMBER, INVITEE] }
  scope :sponsor_contacts, -> { where title: SPONSOR_CONTACT }
  scope :volunteers, -> { where title: VOLUNTEER }
  scope :judgeables, -> { where title: [VOLUNTEER, ADMIN, JUDGE] }

  before_validation :check_competition

  validates :title, inclusion: { in: VALID_ASSIGNMENT_TITLES }
  validate :can_only_join_team_if_registered_for_a_competition_event
  validate :correct_competition

  # ENHANCEMENT: Validation to prevent assignment duplicates.

  after_save :only_one_team_leader

  # Callback to ensure that there is only one team leader per team.
  # Will remove longest serving Team Leader and change to Team Member.
  def only_one_team_leader
    return unless title == TEAM_LEADER

    leader_assignments = assignable.leader_assignments.order updated_at: :asc
    return unless leader_assignments.count > 1

    leader_assignments.first.update title: TEAM_MEMBER
  end

  # A validation to ensure there only participants registered for a competition
  # event is able to join a team in any position.
  def can_only_join_team_if_registered_for_a_competition_event
    return unless TEAM_ADMIN.include? title

    return unless user.event_assignment(competition).registrations.participating.competition_events.empty?

    errors.add :checkpoiUnt_id, 'Register for a competition event to join or create a team.'
  end

  # Returns object for a particular judgeable assignment showing the status of
  # each of the potential teams to be judged.
  # ENHANCEMENT: One line, remove to where it is called.
  def judgeable_scores(teams)
    JudgeableScores.new(self, teams).compile
  end

  # Will return the registrtation for the Competition Event a participant is
  # registered for
  def competition_event_registration
    registrations.competition_events.participating.first
  end

  private

  # Will fill in the competition_id if none has been entered
  def check_competition
    return unless competition_id.nil?

    self.competition_id = correct_competition_id
  end

  # A validation to check that the competition that was attached to the
  # assignment was the correct one as per the assignable entity
  def correct_competition
    return unless correct_competition_id != competition_id

    errors.add :competiton, 'The Competition is not correct'
  end

  # Return the correct competition id for an assignment
  def correct_competition_id
    return assignable_id if assignable_type == 'Competition'

    assignable.competition.id
  end
end
