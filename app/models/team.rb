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

  def admin_available_checkpoints(challenge_type)
    valid_checkpoints = []
    challenge_region = if challenge_type == REGIONAL
                         region
                       else
                         Region.root
                       end
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
    id_team_projects = Team.id_teams_projects(all)
    team_member_counts = {}
    Assignment.where(assignable_type: 'Team').each do |assignment|
      team_member_counts[assignment.assignable_id] ||= 0
      team_member_counts[assignment.assignable_id] += 1
    end

    team_data_sets = {}
    TeamDataSet.all.each do |team_data_set|
      team_data_sets[team_data_set.team_id] ||= []
      team_data_sets[team_data_set.team_id] << team_data_set.url
    end

    team_challenge_names = {}
    id_challenges = Challenge.id_challenges(Challenge.all)
    Entry.all.where(eligible: true).each do |entry|
      team_challenge_names[entry.team_id] ||= []
      team_challenge_names[entry.team_id] << id_challenges[entry.challenge_id].name
    end

    CSV.generate(options) do |csv|
      csv << project_columns + %w[member_count data_sets challenge_names]
      all.where(published: true).each do |team|
        project = id_team_projects[team.id][:current_project]
        csv << project.attributes.values_at(*project_columns) + [team_member_counts[team.id], team_data_sets[team.id], team_challenge_names[team.id]]
      end
    end
  end

  def self.id_teams_projects(teams)
    if teams.class == Array
      team_ids = teams
      teams = where(id: team_ids.uniq)
    else
      team_ids = teams.pluck(:id)
    end

    projects = Project.where(team_id: team_ids.uniq).order(created_at: :desc)
    id_projects = Project.id_projects(projects)

    id_events = Event.id_events(teams.pluck(:event_id))

    team_id_to_projects = {}
    projects.each do |project|
      team_id_to_projects[project.team_id] = [] if team_id_to_projects[project.team_id].nil?
      team_id_to_projects[project.team_id] << project
    end

    id_team_projects = {}
    teams.each do |team|
      project = if team.project_id.present?
                  id_projects[team.project_id]
                else
                  team_id_to_projects[team.id].first
                end
      id_team_projects[team.id] = { team: team, current_project: project,
                                    event: id_events[team.event_id] }
    end

    id_team_projects
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
