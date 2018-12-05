class Competition < ApplicationRecord
  has_many :assignments, as: :assignable
  has_many :sponsors
  has_many :sponsorship_types
  has_many :events
  has_many :teams, through: :events
  has_many :projects, through: :teams
  has_many :challenges
  has_many :checkpoints
  has_many :data_sets
  has_many :criteria
  has_many :project_criteria, -> { where category: PROJECT }, class_name: 'Criterion'
  has_many :challenge_criteria, -> { where category: CHALLENGE }, class_name: 'Criterion'

  validates :year, presence: true

  def name
    "Competition #{year}"
  end

  def self.current
    find_or_create_by(year: Time.current.year)
  end

  def director
    assignment = assignments.where(title: COMPETITION_DIRECTOR).first
    return nil if assignment.nil?

    assignment.user
  end

  def sponsorship_director
    assignment = assignments.where(title: SPONSORSHIP_DIRECTOR).first
    return nil if assignment.nil?

    assignment.user
  end

  def chief_judge
    assignment = assignments.where(title: CHIEF_JUDGE).first
    return nil if assignment.nil?

    assignment.user
  end

  def site_admins
    assignment_user_ids = assignments.where(title: ADMIN).pluck(:user_id)
    return nil if assignment_user_ids.empty?

    User.where(id: assignment_user_ids)
  end

  def management_team
    assignment_user_ids = assignments.where(title: MANAGEMENT_TEAM).pluck(:user_id)
    return nil if assignment_user_ids.empty?

    User.where(id: assignment_user_ids)
  end

  def volunteers
    assignment_user_ids = assignments.where(title: VOLUNTEER).pluck(:user_id)
    return nil if assignment_user_ids.empty?

    User.where(id: assignment_user_ids)
  end

  def admin_assignments
    assignments.where(title: COMP_ADMIN).to_a
  end

  def score_total(type)
    criteria.where(category: type).count * MAX_SCORE
  end

  def filter_data_sets(term)
    sets = data_sets.order(:name)
    id_regions = Region.id_regions(Region.all)
    region_sets = {}
    id_regions.keys.each do |region_id|
      region_sets[region_id] = []
    end
    if term.nil?
      sets.each do |data_set|
        region_sets[data_set.region_id] << data_set
      end
    else
      sets.each do |data_set|
        string = "#{data_set.name} #{data_set.description}" +
                 id_regions[data_set.region_id].name.to_s.downcase
        region_sets[data_set.region_id] << data_set if string.include? term.downcase
      end
    end
    region_sets
  end

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

  def passed_checkpoint_ids(time_zone)
    passed_checkpoint_ids = []
    checkpoints.each do |checkpoint|
      passed_checkpoint_ids << checkpoint.id if checkpoint.passed?(time_zone)
    end
    passed_checkpoint_ids
  end
end
