# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id                 :bigint           not null, primary key
#  published          :boolean          default(TRUE)
#  slack_channel_name :string
#  youth_team         :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  event_id           :integer
#  project_id         :integer
#  slack_channel_id   :string
#
# Indexes
#
#  index_teams_on_event_id    (event_id)
#  index_teams_on_project_id  (project_id)
#  index_teams_on_published   (published)
#
class Team < ApplicationRecord
  belongs_to :event
  belongs_to :current_project, class_name: 'Project', foreign_key: 'project_id', optional: true

  has_one :competition, through: :event
  has_one :region, through: :event

  has_many :assignments, as: :assignable, dependent: :destroy
  has_many :users, through: :assignments

  has_many :member_assignments, -> { team_members }, as: :assignable, class_name: 'Assignment'
  has_many :members, through: :member_assignments, source: :user
  has_many :leader_assignments, -> { team_leaders }, as: :assignable, class_name: 'Assignment'
  has_many :leaders, through: :leader_assignments, source: :user
  has_many :invitee_assignments, -> { team_invitees }, as: :assignable, class_name: 'Assignment'
  has_many :invitees, through: :invitee_assignments, source: :user
  has_many :confirmed_assignments, -> { team_confirmed }, as: :assignable, class_name: 'Assignment'
  has_many :confirmed_members, through: :confirmed_assignments, source: :user

  has_many :confirmed_slack_profiles,
    -> { where.not slack_user_id: nil },
    through: :confirmed_assignments,
    source: :profile

  has_many :projects, dependent: :destroy
  has_many :team_data_sets, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :headers, dependent: :destroy, as: :scoreable

  has_many :entries, dependent: :destroy
  has_many :challenges, through: :entries
  has_many :judges, through: :challenges, source: :judge_users
  has_many :judge_headers, through: :judges, source: :headers
  has_many :regional_entries, -> { regional }, class_name: 'Entry'
  has_many :national_entries, -> { national }, class_name: 'Entry'

  has_one_attached :thumbnail
  has_one_attached :high_res_image

  scope :published, -> { where published: true }
  scope :unpublished, -> { where published: false }
  scope :with_assignments, lambda {
    joins(:assignments).where(
      'EXISTS(
        SELECT assignments.assignable_id
        FROM assignments
        WHERE
          teams.id = assignments.assignable_id
        AND
          assignments.assignable_type = ?
      )', 'Team',
    ).distinct
  }
  scope :with_entries, lambda {
    joins(:entries)
      .where(
        'EXISTS(
          SELECT entries.team_id
          FROM entries
          WHERE teams.id = entries.team_id
        )',
      ).distinct
  }

  scope :competition, lambda { |competition|
    joins(event: :region).where(regions: {competition: competition})
  }

  validate :check_for_ineligible_challenge_entries

  # Returns the user record for the team leader.
  # ENHANCEMENT: Should not be needed.
  def team_leader
    leaders.first
  end

  # Assigns a leader to the team.
  # ENHANCEMENT: Should not be needed.
  def assign_leader(user)
    leader_assignments.create user: user, holder: user.holder_for(competition)
  end

  # Returns the team_name from the latest project.
  # ENHANCEMENT: Move to Helper.
  def name
    return unless current_project.present?

    current_project.team_name
  end

  # Returns true if a given user has an assignment attached to the team.
  # ENHANCEMENT: Move to Helper/Controller
  def permission?(user)
    assignments.where(user: user).present?
  end

  # Returns all the regional challenges that a team has entered at a particular
  # checkpoint
  # ENHANCEMENT: Move everything into active record query
  def regional_challenges(checkpoint)
    challenge_ids = regional_entries.where(checkpoint: checkpoint).pluck(:challenge_id)
    Challenge.where(id: challenge_ids)
  end

  # Returns all the national challenges that a team has entered at a particular
  # checkpoint
  # ENHANCEMENT: Move everything into active record query
  def national_challenges(checkpoint)
    challenge_ids = national_entries.where(checkpoint: checkpoint).pluck(:challenge_id)
    Challenge.where(id: challenge_ids)
  end

  # Returns all the available checkpoints left in a given challenge for a team
  # taking into account time_zone and challenges already entered.
  # ENHANCEMENT: Move to controller or helper.
  def available_checkpoints(challenge)
    competition.available_checkpoints(self, challenge.region)
  end

  # Returns all the available checkpoints left in a given challenge for a team
  # taking into only challenges already entered.
  # ENHANCEMENT: Move to controller or helper.
  def admin_available_checkpoints(_challenge)
    valid_checkpoints = []
    competition.checkpoints.each do |checkpoint|
      # ERROR: Not working correctly at the moment
      # next if checkpoint.limit_reached?(self, challenge_region)

      valid_checkpoints << checkpoint
    end
    valid_checkpoints
  end

  # Returns true if all the checkpoints have passed for a given team. false
  # otherwise.
  # ENHANCEMENT: Move to controller or helper.
  def all_checkpoints_passed?
    team_time_zone = region.time_zone || FIRST_COMPETITION_TIME_ZONE
    competition.checkpoints.each do |checkpoint|
      return false unless checkpoint.passed?(team_time_zone)
    end
    true
  end

  # Given a challenge type, returns all the approved challenges that a team has not yet
  # entered.
  # ENHANCEMENT: Move to controller or helper.
  def available_challenges(challenge_type)
    if challenge_type == REGIONAL
      region.eligible_challenges
    else
      available_national_challenges
    end
  end

  # Returns all the competition events that confirmed members are registered
  # for.
  # ENHANCEMENT: Move to active record query.
  def member_competition_events
    events = []
    comp = competition
    confirmed_members.each do |user|
      events << user.participating_competition_event(comp)
    end
    events.uniq
  end

  # Returns a CSV file with information on the team.
  # ENHANCEMENT: move to controller.
  def self.to_csv(competition)
    project_columns = %w[id identifier team_name project_name source_code_url video_url
                         homepage_url created_at updated_at identifier]
    CSV.generate do |csv|
      csv << (project_columns + %w[member_count data_sets challenge_names])
      compile_csv(competition, csv, project_columns)
    end
  end

  # Inserts a set of attributes into a csv file.
  # ENHANCEMENT: move to controller.
  def self.compile_csv(competition, csv, project_columns)
    competition.teams.published.preload(:current_project, :team_data_sets, :challenges, :assignments).each do |team|
      # csv << [
      #  *team.current_project.attributes.values_at(*project_columns),
      #  team.assignments.length,
      #  team.team_data_sets.pluck(:url),
      #  team.challenges.pluck(:name),
      # ]
      csv << if team.current_project
        [
          *team.current_project.attributes.values_at(*project_columns),
          team.assignments.length,
          team.team_data_sets.pluck(:url),
          team.challenges.pluck(:name),
        ]
      else
        # Handle the case where current_project is nil
        (([nil] * project_columns.length) + [
          team.assignments.length,
          team.team_data_sets.pluck(:url),
          team.challenges.pluck(:name),
        ])
      end
    end
  end

  # Search for teams based on a given term.
  def self.search(competition, term)
    team_ids = competition.projects.search(term).pluck(:team_id).uniq
    Team.where(id: team_ids.uniq)
  end

  private

  def available_regional_challenges
    region.challenges.not_unapproved
      .where.not(id: regional_entries.pluck(:challenge_id))
  end

  def available_national_challenges
    competition.international_region.challenges
      .or(national_region.challenges)
      .not_unapproved
      .where.not(id: national_entries.pluck(:challenge_id))
  end

  def national_region
    return region if region.national?

    raise 'No National!' unless region.parent.national?

    region.parent
  end

  # Will check to see that all challenges are still eligible if team event
  # is amended
  def check_for_ineligible_challenge_entries
    return if event_id.nil?

    return if (challenges - region.eligible_challenges).empty?

    errors.add :entries, 'some challenge entries will not be eligible if team event is changed'
  end
end
