class User < ApplicationRecord
  # Devise options
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :lockable, :timeoutable,
         :omniauthable

  has_many :assignments, dependent: :destroy
  has_many :registrations, through: :assignments

  # Gravitar Gem
  include Gravtastic
  has_gravatar

  # Active Storage prifel image.
  has_one_attached :govhack_img

  def privilege?(privileges)
    (privileges & assignments).present?
  end

  def admin_privileges?
    (assignments.pluck(:title) & COMP_ADMIN).present?
  end

  def region_privileges?
    (assignments.pluck(:title) & REGION_PRIVILEGES).present?
  end

  def event_privileges?
    (assignments.pluck(:title) & EVENT_PRIVILEGES).present?
  end

  def sponsor_privileges?
    (assignments.pluck(:title) & SPONSOR_PRIVILEGES).present?
  end

  def criterion_privileges?
    (assignments.pluck(:title) & CRITERION_PRIVILEGES).present?
  end

  def admin_assignments
    assignments.where(title: ADMIN_TITLES)
  end

  def challenges_judging
    Challenge.where(id: assignments.where(title: JUDGE).pluck(:assignable_id))
  end

  def challenge_scorecards(challenge)
    judge_assignment = Assignment.find_by(user: self, assignable: challenge)
    ChallengeScorecard.update_scorecards!(judge_assignment, challenge)
    judge_assignment.challenge_scorecards
  end

  def make_site_admin
    Competition.current.assignments.find_or_create_by(user: self, title: ADMIN)
  end

  def display_name
    return preferred_name unless preferred_name.blank?
    return full_name unless full_name.blank?
    email
  end

  def event_assignment
    assignment = Competition.current.assignments.find_by(user: self, title: VIP)
    return assignment unless assignment.nil?
    Competition.current.assignments.find_or_create_by(user: self, title: PARTICIPANT)
  end

  def registrations
    event_assignment.registrations
  end

  def teams(event = nil)
    assignment_ids = assignments.where(assignable_type: 'Team').pluck(:assignable_id)
    return if assignment_ids.nil?
    return Team.where(id: assignment_ids, event: event) unless event.nil?
    Team.where(id: assignment_ids)
  end

  def joined_teams
    assignment_ids = assignments.where(assignable_type: 'Team', title: [TEAM_MEMBER, TEAM_LEADER]).pluck(:assignable_id)
    return if assignment_ids.nil?
    Team.where(id: assignment_ids)
  end

  def invited_teams
    assignment_ids = assignments.where(assignable_type: 'Team', title: INVITEE).pluck(:assignable_id)
    return if assignment_ids.nil?
    invited_teams = []
    competition = Competition.current
    Team.where(id: assignment_ids).each do |team|
      invited_teams << team if competition.in_competition_window?(team.time_zone)
    end
    return invited_teams unless invited_teams.empty?
  end

  def in_team?(team)
    return true if assignments.where(assignable: team).present?
    false
  end

  def self.search(term)
    results = []
    User.all.each do |user|
      user_string = "#{user.full_name} #{user.email} #{user.preferred_name}".downcase
      results << user if user_string.include? term.downcase
    end
    results
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.find_by_email(data['email'])
    user ||= new_user_from_google(data)
    update_user_info_from_google(user, data)
    user.save
    user
  end

  def no_dietary_requirements?
    dietary_requirements.blank?
  end

  def registering_account?
    how_did_you_hear.blank?
  end

  def competition_events_participating(competition)
    event_ids = registrations.where(status: [ATTENDING, WAITLIST]).pluck(:event_id)
    Event.where(id: event_ids, competition: competition, event_type: COMPETITION_EVENT)
  end

  def competition_event_participant?
    competition_events_participating(Competition.current).present?
  end

  def self.new_user_from_google(data)
    User.new(full_name: data['name'],
             email: data['email'],
             password: Devise.friendly_token[0, 20])
  end

  def self.update_user_info_from_google(user, data)
    user.update(google_img: data['image'])
    return unless user.full_name.blank?
    user.update(full_name: data['name'])
  end
end
