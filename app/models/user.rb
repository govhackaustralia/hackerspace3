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

  has_many :judge_assignments, -> { judges }, class_name: 'Assignment'
  has_many :challenges_judging, through: :judge_assignments, source: :assignable, source_type: 'Challenge'

  has_many :leader_assignments, -> { team_leaders }, class_name: 'Assignment'
  has_many :leader_teams, through: :leader_assignments, source: :assignable, source_type: 'Team'
  has_many :winning_entries, -> { winners }, through: :leader_teams, source: :entries

  has_many :participating_registrations, -> { participating }, through: :assignments, source: :registrations
  has_many :participating_events, through: :participating_registrations, source: :event
  has_many :participating_competition_events, -> { competitions }, through: :participating_registrations, source: :event

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
    assignments.judges.find_by assignable: challenge
  end

  def self.search(term)
    user_ids = []
    User.all.each do |user|
      user_string = "#{user.full_name} #{user.email} #{user.preferred_name}".downcase
      user_ids << user.id if user_string.include? term.downcase
    end
    User.where(id: user_ids)
  end

  def no_dietary_requirements?
    dietary_requirements.blank?
  end

  def registering_account?
    how_did_you_hear.blank?
  end

  def competition_event_participant?
    participating_competition_events.where(competition: Competition.current).present?
  end

  require 'csv'

  def self.published_teams_to_csv(options = {})
    user_columns = %w[id email full_name preferred_name dietary_requirements tshirt_size twitter mailing_list challenge_sponsor_contact_place challenge_sponsor_contact_enter my_project_sponsor_contact me_govhack_contact phone_number how_did_you_hear accepted_terms_and_conditions registration_type parent_guardian request_not_photographed data_cruncher coder creative facilitator]
    user_ids = Assignment.participants.where(assignable: Team.published).pluck(:user_id).uniq
    CSV.generate(options) do |csv|
      csv << user_columns
      where(id: user_ids).each do |user|
        csv << user.attributes.values_at(*user_columns)
      end
    end
  end

  def self.user_event_rego_to_csv(options = {})
    user_columns = %w[id email full_name preferred_name dietary_requirements tshirt_size twitter mailing_list challenge_sponsor_contact_place challenge_sponsor_contact_enter my_project_sponsor_contact me_govhack_contact phone_number how_did_you_hear accepted_terms_and_conditions registration_type parent_guardian request_not_photographed data_cruncher coder creative facilitator]
    combined = user_columns + ['events']
    CSV.generate(options) do |csv|
      csv << combined
      all.preload(:participating_events).each do |user|
        csv << (user.attributes.values_at(*user_columns) << user.participating_events.pluck(:name))
      end
    end
  end

  def self.all_members_to_csv(options = {})
    columns = %w[team_name project_name full_name email title]
    CSV.generate(options) do |csv|
      csv << columns
      Assignment.participants.preload(:user, assignable: [:current_project]).each do |assignment|
        project = assignment.assignable.current_project
        user = assignment.user
        csv << [project.team_name, project.project_name, user.full_name, user.email, assignment.title]
      end
    end
  end
end
