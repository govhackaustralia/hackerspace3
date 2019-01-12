class User < ApplicationRecord
  # Devise options
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :lockable, :timeoutable,
         :omniauthable

  has_many :assignments, dependent: :destroy
  has_many :teams, through: :assignments, as: :assignable
  has_many :scorecards, through: :assignments
  has_many :registrations, through: :assignments

  has_many :joined_team_assignments, -> { team_confirmed }, class_name: 'Assignment'
  has_many :joined_teams, through: :joined_team_assignments, source: :assignable, source_type: 'Team'

  has_many :invited_team_assignments, -> { team_invitees }, class_name: 'Assignment'
  has_many :invited_teams, through: :invited_team_assignments, source: :assignable, source_type: 'Team'

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

  def judgeable_assignment
    return event_assignment if teams.where(published: true).present?
    return event_assignment if assignments.where(title: [VOLUNTEER, ADMIN, JUDGE]).present?
  end

  def peoples_assignment
    return event_assignment if teams.where(published: true).present?
    return event_assignment if assignments.where(title: VOLUNTEER).present?
  end

  def judge_assignment(challenge)
    Assignment.find_by(user: self, assignable: challenge, title: JUDGE)
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

  def public_winning_entries?
    leader_assignments = assignments.where(title: TEAM_LEADER)
    return false if leader_assignments.empty?
    winning_entries = Entry.where(team_id: leader_assignments.pluck(:assignable_id), award: WINNER).preload(challenge: :region)
    return false if winning_entries.empty?
    winning_entries.each do |entry|
      return true if entry.challenge.region.awards_released?
    end
    false
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

  def self.id_users(users)
    id_users = {}
    users.each { |user| id_users[user.id] = user }
    id_users
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

  require 'csv'

  def self.published_teams_to_csv(options = {})
    user_columns = %w[id email full_name preferred_name dietary_requirements tshirt_size twitter mailing_list challenge_sponsor_contact_place challenge_sponsor_contact_enter my_project_sponsor_contact me_govhack_contact phone_number how_did_you_hear accepted_terms_and_conditions registration_type parent_guardian request_not_photographed data_cruncher coder creative facilitator]
    user_ids = Assignment.where(title: [TEAM_MEMBER, TEAM_LEADER, INVITEE], assignable: Team.where(published: true)).pluck(:user_id).uniq
    CSV.generate(options) do |csv|
      csv << user_columns
      where(id: user_ids).each do |user|
        csv << user.attributes.values_at(*user_columns)
      end
    end
  end

  def self.user_event_rego_to_csv(options = {})
    user_columns = %w[id email full_name preferred_name dietary_requirements tshirt_size twitter mailing_list challenge_sponsor_contact_place challenge_sponsor_contact_enter my_project_sponsor_contact me_govhack_contact phone_number how_did_you_hear accepted_terms_and_conditions registration_type parent_guardian request_not_photographed data_cruncher coder creative facilitator]
    user_event_helper = event_helper
    combined = user_columns + ['events']
    CSV.generate(options) do |csv|
      csv << combined
      all.each do |user|
        csv << (user.attributes.values_at(*user_columns) << user_event_helper[user.id])
      end
    end
  end

  def self.all_members_to_csv(options = {})
    columns = %w[team_name project_name full_name email title]
    assignments = Assignment.where(title: [TEAM_MEMBER, TEAM_LEADER, INVITEE]).preload(assignable: [:current_project])
    id_users = {}
    User.all.each {|user| id_users[user.id] = user }
    CSV.generate(options) do |csv|
      csv << columns
      assignments.each do |assignment|
        project = assignment.assignable.current_project
        user = id_users[assignment.user_id]
        csv << [project.team_name, project.project_name, user.full_name, user.email, assignment.title]
      end
    end
  end

  def self.event_helper
    user_id_to_event = {}
    all.each { |user| user_id_to_event[user.id] = [] }
    registrations = Registration.all.where(status: [ATTENDING, WAITLIST])
    id_assignments = Assignment.id_assignments(registrations.pluck(:assignment_id))
    registrations.preload(:event).each do |registration|
      assignment = id_assignments[registration.assignment_id]
      user_id_to_event[assignment.user_id] << registration.event.name
    end
    user_id_to_event
  end
end
