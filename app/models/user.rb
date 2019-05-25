class User < ApplicationRecord
  # Devise options
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :lockable, :timeoutable,
         :omniauthable

  has_many :assignments, dependent: :destroy
  has_many :favourite_teams, through: :assignments, as: :assignable
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

  has_many :staff_assignments, -> { staff }, class_name: 'Assignment'

  scope :search, ->(term) { where 'full_name ILIKE ? OR email ILIKE ? OR preferred_name ILIKE ?', "%#{term}%", "%#{term}%", "%#{term}%" }

  # Gravitar Gem
  include Gravtastic
  has_gravatar

  # Active Storage prifel image.
  has_one_attached :govhack_img

  # ENHANCEMENT: Need validation to make sure email is fully formed.

  # Returns true if a user has any of the privileges (assignments) passed
  # through the parameters.
  # ENHANCEMENT: Move to Controller.
  def privilege?(privileges)
    (privileges & assignments).present?
  end

  # Returns true if a user has any competition admin titles.
  # ENHANCEMENT: Move to Controller.
  # ENHANCEMENT: Check against assignments not titles.
  def admin_privileges?
    (assignments.pluck(:title) & COMP_ADMIN).present?
  end

  # Returns true if a user has any region admin titles.
  # ENHANCEMENT: Move to Controller.
  # ENHANCEMENT: Check against assignments not titles.
  def region_privileges?
    (assignments.pluck(:title) & REGION_PRIVILEGES).present?
  end

  # Returns true if a user has any event admin titles.
  # ENHANCEMENT: Move to Controller.
  # ENHANCEMENT: Check against assignments not titles.
  def event_privileges?
    (assignments.pluck(:title) & EVENT_PRIVILEGES).present?
  end

  # Returns true if a user has any sponsor admin titles.
  # ENHANCEMENT: Move to Controller.
  # ENHANCEMENT: Check against assignments not titles.
  def sponsor_privileges?
    (assignments.pluck(:title) & SPONSOR_PRIVILEGES).present?
  end

  # Returns true if a user has any criterion admin titles.
  # ENHANCEMENT: Move to Controller.
  # ENHANCEMENT: Check against assignments not titles.
  def criterion_privileges?
    (assignments.pluck(:title) & CRITERION_PRIVILEGES).present?
  end

  # Returns true if a user has any admin titles.
  # ENHANCEMENT: Move to Controller.
  # ENHANCEMENT: Check against assignments not titles.
  def admin_assignments
    assignments.where(title: ADMIN_TITLES)
  end

  # Assigns a user the assignment of site admin.
  def make_site_admin
    Competition.current.assignments.find_or_create_by(user: self, title: ADMIN)
  end

  # Returns a display name in order of system preference.
  def display_name
    return preferred_name unless preferred_name.blank?
    return full_name unless full_name.blank?

    email
  end

  # Returns the event assignment of a particular user.
  # This is the assignment to the competition that is used to register for
  # events (among other things), in a given competition.
  def event_assignment(competition)
    assignment = competition.assignments.find_by(user: self, title: VIP)
    return assignment unless assignment.nil?

    competition.assignments.find_or_create_by(user: self, title: PARTICIPANT)
  end

  # Returns all event assignments for user across all competitions
  def event_assignments
    assignments.where title: [VIP, PARTICIPANT]
  end

  # Returns a user's event_assignment if they have permission to vote.
  def judgeable_assignment(competition)
    event_assignment competition if
      joined_teams.published.present? ||
      assignments.judgeables.present?
  end

  # Returns a user's event_assignment if they have permission to vote in the
  # people's choice awards.
  def peoples_assignment(competition)
    event_assignment competition if
      joined_teams.published.present? ||
      assignments.volunteers.present?
  end

  # Returns a user's challenge judging assignment given a challenge.
  def judge_assignment(challenge)
    assignments.judges.find_by assignable: challenge
  end

  # Returns true if a user has no set dietary requirements.
  def no_dietary_requirements?
    dietary_requirements.blank?
  end

  # Returns true if a user is in the process of registering an account.
  # After an account has been created if the how_did_you_hear section is not
  # filled out, a placeholder will be set.
  def registering_account?
    how_did_you_hear.blank?
  end

  # Returns true if an user is participating in a competition event.
  def competition_event_participant?
    participating_competition_events.where(competition: Competition.current).present?
  end

  require 'csv'

  # Generates a CSV file for published teams and their selected attributes.
  # ENHANCEMENT: move to Controller or other model.
  def self.published_teams_to_csv(options = {})
    user_columns = %w[id email full_name preferred_name dietary_requirements tshirt_size twitter mailing_list challenge_sponsor_contact_place challenge_sponsor_contact_enter my_project_sponsor_contact me_govhack_contact phone_number how_did_you_hear accepted_terms_and_conditions registration_type parent_guardian request_not_photographed data_cruncher coder creative facilitator]
    # ENHANCEMENT: Create a scope for the below.
    user_ids = Assignment.participants.where(assignable: Team.published).pluck(:user_id).uniq
    CSV.generate(options) do |csv|
      csv << user_columns
      where(id: user_ids).each do |user|
        csv << user.attributes.values_at(*user_columns)
      end
    end
  end

  # Generates a CSV file of user attributes and the events they are registered
  # for as participating.
  # ENHANCEMENT: move to Controller or other model.
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

  # Generates a CSV file for all participating team members and their
  # attributes.
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
