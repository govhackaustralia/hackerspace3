class Team < ApplicationRecord
  has_many :assignments, as: :assignable
  belongs_to :event
  has_one :competition, through: :event
  has_one :region, through: :event
  has_many :projects, dependent: :destroy
  has_many :team_data_sets, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :peoples_scorecards, dependent: :destroy
  has_many :challenges, through: :entries
  has_many :favourites, dependent: :destroy

  has_one_attached :thumbnail
  has_one_attached :high_res_image

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

  def current_project
    return Project.find(project_id) unless project_id.nil?
    projects.order(created_at: :desc).first
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
    event.region.time_zone
  end

  def available_checkpoints(challenge)
    competition.available_checkpoints(self, challenge.region)
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
    assignment_ids = Assignment.where(user_id: user_ids, title: [PARTICIPANT, VIP]).pluck(:id)
    event_ids = Registration.where(assignment_id: assignment_ids).pluck(:event_id)
    Event.where(id: event_ids.uniq, event_type: COMPETITION_EVENT)
  end

  def permission?(user)
    assignments.where(user: user).present?
  end

  def self.to_csv(options = {})
    project_columns = %w[team_name source_code_url video_url homepage_url created_at updated_at]
    CSV.generate(options) do |csv|
      csv << project_columns
      all.each do |team|
        csv << team.current_project.attributes.values_at(*project_columns)
      end
    end
  end

  def self.id_teams_projects(team_ids)
    teams = where(id: team_ids.uniq)
    id_team_projects = {}

    projects = Project.where(team_id: team_ids.uniq).order(created_at: :desc)
    id_projects = Project.id_projects(projects)

    id_events = Event.id_events(teams.pluck(:event_id))

    team_id_to_projects = {}
    projects.each do |project|
      if team_id_to_projects[project.team_id].nil?
        team_id_to_projects[project.team_id] = []
      end
      team_id_to_projects[project.team_id] << project
    end

    teams.each do |team|
      project = if team.project_id.present?
                  id_projects[team.project_id]
                else
                  team_id_to_projects[team.id].first
                end
      id_team_projects[team.id] = { team: team, current_project: project, event: id_events[team.event_id] }
    end

    id_team_projects
  end
end
