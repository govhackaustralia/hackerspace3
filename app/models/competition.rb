class Competition < ApplicationRecord
  has_many :assignments, as: :assignable
  has_many :sponsors
  has_many :sponsorship_types

  has_many :events
  has_many :teams, through: :events
  has_many :projects, through: :teams
  has_many :peoples_scorecards, through: :teams
  has_many :peoples_judgements, through: :peoples_scorecards

  has_many :challenges
  has_many :checkpoints
  has_many :data_sets
  has_many :criteria

  validates :year, presence: true

  def name
    "Competition #{year}"
  end

  def region_criteria
    criteria.where(category: REGIONAL_CHALLENGE)
  end

  def peoples_criteria
    criteria.where(category: PEOPLES_CHOICE)
  end

  def assignment_privileges(_action, _access)
    assignments.where(title: [MANAGEMENT_TEAM, ADMIN, COMPETITION_DIRECTOR])
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

  def events_on?(type)
    events.where(type: type).present?
  end

  def started?(time_zone = nil)
    region_time = if time_zone.present?
                    Time.now.in_time_zone(time_zone).to_formatted_s(:number)
                  else
                    Time.now.in_time_zone(COMP_TIME_ZONE).to_formatted_s(:number)
                  end
    start_time.to_formatted_s(:number) < region_time
  end

  def not_finished?(time_zone = nil)
    region_time = if time_zone.present?
                    Time.now.in_time_zone(time_zone).to_formatted_s(:number)
                  else
                    Time.now.in_time_zone(COMP_TIME_ZONE).to_formatted_s(:number)
                  end
    region_time < end_time.to_formatted_s(:number)
  end

  def in_competition_window?(time_zone = nil)
    started?(time_zone) && not_finished?(time_zone)
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
        if string.include? term.downcase
          region_sets[data_set.region_id] << data_set
        end
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
