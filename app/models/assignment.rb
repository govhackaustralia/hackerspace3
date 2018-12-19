class Assignment < ApplicationRecord
  belongs_to :assignable, polymorphic: true
  belongs_to :user
  has_many :registrations, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :teams, through: :favourites
  has_many :scorecards, dependent: :destroy

  validates :title, inclusion: { in: VALID_ASSIGNMENT_TITLES }
  validate :can_only_join_team_if_registered_for_a_competition_event

  after_save :only_one_team_leader

  scope :event_hosts, -> { where(title: EVENT_HOST) }
  scope :event_supports, -> { where(title: EVENT_SUPPORT) }
  
  # Callback to ensure that there is only one team leader per team.
  # Will remove longest serving Team Leader and change to Team Member.
  def only_one_team_leader
    return unless title == TEAM_LEADER

    leader_assignments = Assignment.where(assignable: assignable, title: TEAM_LEADER).order(updated_at: :asc)
    return unless leader_assignments.count > 1

    leader_assignments.first.update(title: TEAM_MEMBER)
  end

  # A validation to ensure there only participants registered for a competition
  # event is able to join a team in any position.
  def can_only_join_team_if_registered_for_a_competition_event
    return unless [TEAM_MEMBER, TEAM_LEADER, INVITEE].include? title

    registration_event_ids = user.registrations.where(status: [ATTENDING, WAITLIST]).pluck(:event_id)
    competition_event_ids = Competition.current.events.where(event_type: COMPETITION_EVENT).pluck(:id)
    errors.add(:checkpoint_id, 'Register for a competition event to join or create a team.') if (registration_event_ids & competition_event_ids).empty?
  end

  # Class method to organise methods into key value pairs.
  # ENHANCEMENT: Common method, find standard alternative.
  # ENHANCEMENT: This should be in the helpers.
  def self.id_assignments(assignments)
    assignments = where(id: assignments.uniq) if assignments.class == Array
    id_assignments = {}
    assignments.each { |assignment| id_assignments[assignment.id] = assignment }
    id_assignments
  end

  # Returns object for a particular judgeable assignment showing the status of
  # each of the potential teams to be judged.
  # ENHANCEMENT: This should be in the helpers.
  def judgeable_scores(teams)
    team_id_to_scorecard = {}
    if title == JUDGE
      entries = Entry.where(team: teams, challenge: assignable)
      team_scorecards = scorecards.where(judgeable: entries)
      id_to_entry = {}
      entries.each { |entry| id_to_entry[entry.id] = entry }
      team_scorecards.each do |scorecard|
        entry = id_to_entry[scorecard.judgeable_id]
        team_id_to_scorecard[entry.team_id] = scorecard
      end
    else
      user_team_ids = user.teams.pluck(:id)
      team_scorecards = scorecards.where(judgeable: teams)
      team_scorecards.each { |scorecard| team_id_to_scorecard[scorecard.judgeable_id] = scorecard }
    end

    scorecard_id_to_scores = {}
    team_scorecards.each { |scorecard| scorecard_id_to_scores[scorecard.id] = [] }

    judgments = Judgment.where(scorecard: team_scorecards)
    judgments.each { |judgment| scorecard_id_to_scores[judgment.scorecard_id] << judgment.score }

    judgeable_scores_obj = {}
    teams.each do |team|
      verdict = if title != JUDGE && user_team_ids.include?(team.id)
                  'Your Team'
                elsif (scorecard = team_id_to_scorecard[team.id]).nil?
                  'Not Marked'
                elsif (scores = scorecard_id_to_scores[scorecard.id]).include? nil
                  'Incomplete'
                else
                  scores.sum
                end
      judgeable_scores_obj[team.id] = { display_score_status: verdict }
    end
    judgeable_scores_obj
  end

  # Returns an object of assignments belonging to particular user.
  # ENHANCEMENT: This should be in the helpers.
  def self.user_id_assignments(users)
    user_id_assignments = {}
    users.each { |user| user_id_assignments[user.id] = [] }
    assignments = Assignment.where(user_id: user_id_assignments.keys)
    assignments.each do |assignment|
      user_id_assignments[assignment.user_id] << assignment
    end
    user_id_assignments
  end
end
