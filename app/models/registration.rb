# frozen_string_literal: true

# == Schema Information
#
# Table name: registrations
#
#  id            :bigint           not null, primary key
#  status        :string
#  time_notified :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  assignment_id :integer
#  event_id      :integer
#  holder_id     :integer
#
# Indexes
#
#  index_registrations_on_assignment_id  (assignment_id)
#  index_registrations_on_event_id       (event_id)
#  index_registrations_on_holder_id      (holder_id)
#  index_registrations_on_status         (status)
#
class Registration < ApplicationRecord
  belongs_to :holder
  belongs_to :assignment
  belongs_to :event

  has_one :user, through: :assignment
  has_one :competition, through: :assignment

  scope :attending, -> { where status: ATTENDING }
  scope :waitlist, -> { where status: WAITLIST }
  scope :non_attending, -> { where status: NON_ATTENDING }
  scope :invited, -> { where status: INVITED }
  scope :participating, -> { where status: [ATTENDING, WAITLIST] }

  scope :participants, lambda {
    joins(:assignment).where(assignments: { title: PARTICIPANT })
  }
  scope :vips, lambda {
    joins(:assignment).where(assignments: { title: VIP })
  }
  scope :connection_events, lambda {
    joins(:event).where(events: { event_type: CONNECTION_EVENT })
  }
  scope :conference_events, lambda {
    joins(:event).where(events: { event_type: CONFERENCE })
  }
  scope :competition_events, lambda {
    joins(:event).where(events: { event_type: COMPETITION_EVENT })
  }
  scope :award_events, lambda {
    joins(:event).where(events: { event_type: AWARD_EVENT })
  }
  scope :competition, lambda { |competition|
    joins(:assignment).where(assignments: { competition_id: competition.id })
  }

  scope :aws_credits_requested, lambda {
    joins(:holder).where(holders: { aws_credits_requested: true })
  }

  after_update_commit :check_for_newly_freed_space

  validates :status, presence: true
  validates :status, inclusion: { in: VALID_ATTENDANCE_STATUSES }
  validates :assignment_id, uniqueness: {
    scope: :event_id,
    message: 'Registration already exists'
  }

  validate :check_for_existing_competition_registrations,
           :check_for_team_assignments,
           :check_code_of_conduct

  validate :check_user_registration_type, on: :create

  private

  # Triggers call back to check for space in an event, usually for someone else.
  # ENHANCEMENT: Probably bad practice.
  def check_for_newly_freed_space
    event.check_for_newly_freed_space
  end

  # Check to see if a user is already participating in a competition event for
  # the current competition.
  def check_for_existing_competition_registrations
    return if status == NON_ATTENDING || assignment_id.nil? || event.event_type != COMPETITION_EVENT

    comp_events = assignment.registrations.competition_events.participating
    return if (comp_events - [self]).empty?

    errors.add :user, 'already registered for a competition event'
  end

  # Check to see if a user is has an assignment to team in the relelevent
  # competition
  def check_for_team_assignments
    return if status == ATTENDING || assignment_id.nil?

    return unless user_is_trying_to_edit_their_competition_event_registration?

    return unless user_has_team_assignments_for_this_competition?

    errors.add :user, 'needs to leave teams or decline invitations before amending registration'
  end

  def user_is_trying_to_edit_their_competition_event_registration?
    user.participating_competition_events.competition(competition).include? event
  end

  def user_has_team_assignments_for_this_competition?
    user.assignments.team_participants.where(competition: competition).present?
  end

  # Checks if the Registration's User has accepted the code of conduct.
  def check_code_of_conduct
    return if assignment_id.nil? || user.accepted_code_of_conduct

    errors.add :user, 'please agree to the Code of Conduct'
  end

  def check_user_registration_type
    return unless event.event_type == COMPETITION_EVENT

    return if user.registration_type.present?

    errors.add :user, 'please select a registration type'
  end
end
