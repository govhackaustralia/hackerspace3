class Competition < ApplicationRecord
  has_many :assignments, as: :assignable
  has_many :regions
  has_many :sponsors
  has_many :sponsorship_types
  has_many :competition_assignments, class_name: 'Assignment'

  has_many :events, through: :regions
  has_many :connection_events, -> { connections }, through: :regions, source: :events
  has_many :connection_registrations, through: :connection_events, source: :registrations
  has_many :competition_events, -> { competitions }, through: :regions, source: :events
  has_many :competition_registrations, through: :competition_events, source: :registrations
  has_many :award_events, -> { awards }, through: :regions, source: :events
  has_many :award_registrations, through: :award_events, source: :registrations

  has_many :teams, through: :events
  has_many :projects_by_name, through: :events
  has_many :published_projects_by_name, through: :events
  has_many :projects, through: :teams
  has_many :challenges, through: :regions
  has_many :checkpoints
  has_many :data_sets, through: :regions

  has_many :criteria
  has_many :project_criteria, -> { where category: PROJECT }, class_name: 'Criterion'
  has_many :challenge_criteria, -> { where category: CHALLENGE }, class_name: 'Criterion'

  validates :year, :start_time, :end_time, :peoples_choice_start,
            :peoples_choice_end, :challenge_judging_start,
            :challenge_judging_end, presence: true

  validates :year, uniqueness: true

  after_save :only_one_current

  # Returns the name of a competiton.
  def name
    "Competition #{year}"
  end

  # Returns the competiton for the current year.
  def self.current
    find_by current: true
  end

  # Returns the parent region of all the competition's regions
  def root_region
    regions.roots.first
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
  # ENHANCEMENT: See if this search can be done at the DB level.
  def passed_checkpoint_ids(time_zone)
    passed_checkpoint_ids = []
    checkpoints.each do |checkpoint|
      passed_checkpoint_ids << checkpoint.id if checkpoint.passed?(time_zone)
    end
    passed_checkpoint_ids
  end

  # Returns true if the competition has started, false otherwise.
  def started?(time_zone = nil)
    start_time.to_formatted_s(:number) < region_time(time_zone)
  end

  # Returns true if the competition has not finished, false otherwise.
  def not_finished?(time_zone = nil)
    region_time(time_zone) < end_time.to_formatted_s(:number)
  end

  # Returns true if the competition is running, false otherwise.
  def in_window?(time_zone = nil)
    started?(time_zone) && not_finished?(time_zone)
  end

  # Returns true if the competition is in the judging period, false oherwise.
  def in_challenge_judging_window?(time_zone = nil)
    in_region_window? time_zone, challenge_judging_start, challenge_judging_end
  end

  # Returns true if the competition is in the peoples choice judging window
  # false otherwise.
  def in_peoples_judging_window?(time_zone = nil)
    in_region_window? time_zone, peoples_choice_start, peoples_choice_end
  end

  # Returns true if the competiton is in either the challenge judging window
  # or the competition judging window.
  def either_judging_window_open?(time_zone = nil)
    in_challenge_judging_window?(time_zone) ||
      in_peoples_judging_window?(time_zone)
  end

  private

  # Returns true if a time is within a window for a particular region.
  def in_region_window?(time_zone, start_time, end_time)
    time = region_time(time_zone)
    started = start_time.to_formatted_s(:number) < time
    not_finished = time < end_time.to_formatted_s(:number)
    started && not_finished
  end

  # Returns the time in a particular region.
  def region_time(time_zone)
    if time_zone.present?
      Time.now.in_time_zone(time_zone).to_formatted_s(:number)
    else
      Time.now.in_time_zone(COMP_TIME_ZONE).to_formatted_s(:number)
    end
  end

  def only_one_current
    return unless current

    Competition.where.not(id: id).update_all current: false
  end
end
