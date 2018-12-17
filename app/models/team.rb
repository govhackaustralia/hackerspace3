class Team < ApplicationRecord
  has_many :assignments, as: :assignable
  has_many :users, through: :assignments
  has_many :member_assignments, -> { where(title: TEAM_MEMBER) }, as: :assignable, class_name: 'Assignment'
  has_many :members, through: :member_assignments, source: :user
  has_many :leader_assignments, -> { where(title: TEAM_LEADER) }, as: :assignable, class_name: 'Assignment'
  has_many :leaders, through: :leader_assignments, source: :user
  belongs_to :event
  has_one :competition, through: :event
  has_one :region, through: :event
  has_many :projects, dependent: :destroy
  belongs_to :current_project, class_name: 'Project', foreign_key: 'project_id', optional: true
  has_many :team_data_sets, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :challenges, through: :entries
  has_many :judges, through: :challenges, source: :users
  has_many :judge_scorecards, through: :judges, source: :scorecards

  has_many :favourites, dependent: :destroy
  has_many :scorecards, dependent: :destroy, as: :judgeable

  has_one_attached :thumbnail
  has_one_attached :high_res_image

  scope :published, -> { where(published: true) }

  def team_leader
    assignment = Assignment.find_by(assignable: self, title: TEAM_LEADER)
    return if assignment.nil?

    assignment.user
  end

  def assign_leader(user)
    assignments.create(title: TEAM_LEADER, user: user)
  end

  def team_members
    ids = assignments.where(title: TEAM_MEMBER).pluck(:user_id)
    return if ids.empty?

    User.where(id: ids)
  end

  def invitees
    ids = assignments.where(title: INVITEE).pluck(:user_id)
    return if ids.empty?

    User.where(id: ids)
  end

  def name
    current_project.team_name
  end

  def regional_challenges(checkpoint)
    challenge_ids = entries.where(checkpoint: checkpoint).pluck(:challenge_id)
    regional_challenges = []
    national_region_id = Region.root.id
    Challenge.where(id: challenge_ids).each do |challenge|
      next if challenge.region_id == national_region_id

      regional_challenges << challenge
    end
    regional_challenges
  end

  def national_challenges(checkpoint)
    challenge_ids = entries.where(checkpoint: checkpoint).pluck(:challenge_id)
    national_challenges = []
    national_region_id = Region.root.id
    Challenge.where(id: challenge_ids).each do |challenge|
      next unless challenge.region_id == national_region_id

      national_challenges << challenge
    end
    national_challenges
  end

  def time_zone
    region.time_zone
  end

  def available_checkpoints(challenge)
    competition.available_checkpoints(self, challenge.region)
  end

  def admin_available_checkpoints(challenge)
    valid_checkpoints = []
    challenge_region = challenge.region
    competition.checkpoints.each do |checkpoint|
      next if checkpoint.limit_reached?(self, challenge_region)

      valid_checkpoints << checkpoint
    end
    valid_checkpoints
  end

  def all_checkpoints_passed?
    team_time_zone = time_zone
    competition.checkpoints.each do |checkpoint|
      return false unless checkpoint.passed?(team_time_zone)
    end
    true
  end

  def available_challenges(challenge_type)
    if challenge_type == REGIONAL
      region.challenges.where.not(id: entries.pluck(:challenge_id), approved: false)
    else
      Region.root.challenges.where.not(id: entries.pluck(:challenge_id), approved: false)
    end
  end

  def member_competition_events
    user_ids = assignments.where(title: [TEAM_LEADER, TEAM_MEMBER]).pluck(:user_id)
    assignment_ids = Assignment.where(user_id: user_ids, title: EVENT_ASSIGNMENTS).pluck(:id)
    event_ids = Registration.where(assignment_id: assignment_ids).pluck(:event_id)
    Event.where(id: event_ids.uniq, event_type: COMPETITION_EVENT)
  end

  def permission?(user)
    assignments.where(user: user).present?
  end

  def self.to_csv(options = {})
    project_columns = %w[team_name project_name source_code_url video_url homepage_url created_at updated_at identifier]
    CSV.generate(options) do |csv|
      csv << project_columns + %w[member_count data_sets challenge_names]
      compile_csv(csv, project_columns)
    end
  end

  def self.compile_csv(csv, project_columns)
    all.published.preload(:current_project, :team_data_sets, :challenges, :assignments).each do |team|
      csv << team.current_project.attributes.values_at(*project_columns) + [team.assignments.length, team.team_data_sets.pluck(:url), team.challenges.pluck(:name)]
    end
  end

  def self.search(term)
    team_ids = []
    Project.all.each do |project|
      team_name = project.team_name
      project_name = project.project_name
      team_string = "#{team_name} #{project_name}".downcase
      next unless team_string.include? term.downcase

      team_ids << project.team_id
    end
    return nil if team_ids.empty?

    Team.where(id: team_ids.uniq)
  end
end
