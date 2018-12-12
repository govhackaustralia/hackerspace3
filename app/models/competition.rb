class Competition < ApplicationRecord
  has_many :assignments, as: :assignable
  has_many :sponsors
  has_many :sponsorship_types
  has_many :events
  has_many :teams, through: :events
  has_many :projects_by_name, through: :events
  has_many :published_projects_by_name, through: :events
  has_many :projects, through: :teams
  has_many :challenges
  has_many :checkpoints
  has_many :data_sets
  has_many :criteria
  has_many :project_criteria, -> { where category: PROJECT }, class_name: 'Criterion'
  has_many :challenge_criteria, -> { where category: CHALLENGE }, class_name: 'Criterion'

  validates :year, presence: true

  # Returns the name of a competiton.
  def name
    "Competition #{year}"
  end

  # Returns the competiton for the current year.
  def self.current
    find_or_create_by(year: Time.current.year)
  end

  # Returns the User of the current Competiton Director, if any
  # ENHANCEMENT: create a validation to make sure there is only ever one
  # director.
  def director
    assignment = assignments.where(title: COMPETITION_DIRECTOR).first
    assignment.nil? ? nil : assignment.user
  end

  # Returns the User of the current Sponsorship Director, if any
  # ENHANCEMENT: create a validation to make sure there is only ever one
  # director.
  def sponsorship_director
    assignment = assignments.where(title: SPONSORSHIP_DIRECTOR).first
    assignment.nil? ? nil : assignment.user
  end

  # Returns the User of the current Chief Judge, if any
  # ENHANCEMENT: create a validation to make sure there is only ever one
  # chief judge.
  def chief_judge
    assignment = assignments.where(title: CHIEF_JUDGE).first
    assignment.nil? ? nil : assignment.user
  end

  # Returns an active record query with all site admins, if any
  def site_admins
    assignment_user_ids = assignments.where(title: ADMIN).pluck(:user_id)
    assignment_user_ids.empty? ? nil : User.where(id: assignment_user_ids)
  end

  # Returns an active record query with all management team members, if any
  def management_team
    assignment_user_ids = assignments.where(title: MANAGEMENT_TEAM).pluck(:user_id)
    assignment_user_ids.empty? ? nil : User.where(id: assignment_user_ids)
  end

  # Returns an active record query with all volunteer members, if any
  def volunteers
    assignment_user_ids = assignments.where(title: VOLUNTEER).pluck(:user_id)
    assignment_user_ids.empty? ? nil : User.where(id: assignment_user_ids)
  end

  # Returns an array of admin assignments attached to a competition.
  def admin_assignments
    assignments.where(title: COMP_ADMIN).to_a
  end

  # Returns the highest possible cumulitve score possible across a Competiton
  # criteria type. (Challenge or Project)
  def score_total(type)
    criteria.where(category: type).count * MAX_SCORE
  end

  # Returns an array containing all the available checkpoints for a team in a
  # particular region.
  # ENHANCEMENT: This should be somewhere else.
  def available_checkpoints(team, region)
    valid_checkpoints = []
    team_time_zone = team.time_zone
    checkpoints.each do |checkpoint|
      next if checkpoint.passed?(team_time_zone)
      next if checkpoint.limit_reached?(team, region)

      valid_checkpoints << checkpoint
    end
    valid_checkpoints
  end

  # Returns an array of all the checkpoints that have passed.
  # ENHANCEMENT: This should be somewhere else.
  def passed_checkpoint_ids(time_zone)
    passed_checkpoint_ids = []
    checkpoints.each do |checkpoint|
      passed_checkpoint_ids << checkpoint.id if checkpoint.passed?(time_zone)
    end
    passed_checkpoint_ids
  end
end
