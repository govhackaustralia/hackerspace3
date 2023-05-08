# == Schema Information
#
# Table name: headers
#
#  id             :bigint           not null, primary key
#  assignment_id  :integer
#  scoreable_type :string
#  scoreable_id   :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  included       :boolean          default(TRUE)
#
class Header < ApplicationRecord
  belongs_to :scoreable, polymorphic: true
  belongs_to :assignment

  has_one :user, through: :assignment

  has_many :scores, dependent: :destroy
  has_many :assignment_headers, through: :assignment, source: :headers
  has_many :assignment_scores, through: :assignment_headers,
    source: :scores

  validates :assignment, uniqueness: {
    scope: :scoreable,
    message: 'Only one scorecard allowed per scoreable entity'
  }

  validate :cannot_judge_your_own_team

  scope :included, -> { where included: true }

  # Check thats a scorecard judgements are consistent with most recent
  # competition criteria.
  # ENHANCEMENT: Move the responsibility of making sure the scorecards
  # conform to the correct amount of criteria, to the Criteria and make the
  # process of creating scores more RESTful.
  def update_scores
    criteria_ids = scoreable.competition.criteria.where(category: type).pluck(:id)
    score_card_criteria_ids = scores.pluck(:criterion_id)
    (criteria_ids - score_card_criteria_ids).each do |criterion_id|
      scores.create! criterion_id: criterion_id
    end
  end

  # Returns whether a scorecard is attached to an Entry and is therefore a
  # a challenge scorecard or attached to a Team and is therfore a Team/Project/
  # scorecard.
  def type
    scoreable_type == 'Entry' ? CHALLENGE : PROJECT
  end

  # Ensure that a scorecard is note created where by a team member is not
  # able to judge their own team.
  def cannot_judge_your_own_team
    return if scoreable_type == 'Entry' || scoreable.users.exclude?(user)

    errors.add(:assignment_id, 'Participants are not permitted to vote for a team they are a member of.')
  end

  # Returns the total score of all a scorecard's scores, or nil if any one
  # of the scores has a nil value for score.
  def total_score
    scores.pluck(:entry).sum
  rescue StandardError
    nil
  end

  # Returns a view friendly score.
  # ENHANCEMENT: Move to a helper.
  def display_score
    (score = total_score).nil? ? 'Scorecard Incomplete' : score
  end

  # Returns the maximum possible score that can be obtained from all a
  # competition's criteria in given score type.
  def max_score
    scoreable.competition.score_total type
  end

  def self.participant_headers(competition, teams, include_judges)
    # Returns all project based judging scorecards.
    all_headers = Header.included.where(scoreable: teams).order(:assignment_id).preload(:scores)
    return all_headers if include_judges

    # if include judges false finds all the project scorecard associated
    # with judges and removes them from the set.
    judge_user_ids = competition.assignments.judges.pluck(:user_id)
    judge_assignment_ids = Assignment.event_assignments.where(user_id: judge_user_ids).pluck(:id)
    judge_headers = Header.included.where(assignment_id: judge_assignment_ids)
    all_headers - judge_headers
  end

  # Compiles statistics on a team's (practically) project scorecards.
  # Returns an object of type { team_id: { scorecards: [:id, ...],
  # scores: [:mean_score, ...], total_card_count: :count }, ... }
  def self.region_helper(competition, teams, type, include_judges)
    # Retrieves the relevant scorecards, all off them unless include judges is
    # false then removes those.
    headers = participant_headers(competition, teams, include_judges)

    # Creates an object for every published team so with field scorecards,
    # scores.
    region_helper = {}
    teams.each do |team|
      region_helper[team.id] = { headers: [], scores: [] }
    end

    headers.each do |header|
      region_helper[header.scoreable_id][:headers] << header.id
    end

    headers.each do |header|
      header_count = region_helper[header.scoreable_id][:headers].count
      region_helper[header.scoreable_id][:total_card_count] = header_count
    end

    # Will not 'scores' (a scorecards scores) that have fewer entries than
    # they are supposed to, have entries that are incomplete
    correct_score_count = competition.criteria.where(category: type).count
    headers.each do |header|
      scores = header.scores.pluck(:entry)
      next unless scores.count == correct_score_count
      next if scores.include? nil

      scores.extend(DescriptiveStatistics)
      region_helper[header.scoreable_id][:scores] << scores.mean
    end
    region_helper
  end
end
