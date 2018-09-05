class ChallengeScorecard < ApplicationRecord
  belongs_to :assignment
  belongs_to :entry

  has_many :challenge_judgements, dependent: :destroy, inverse_of: :challenge_scorecard
  accepts_nested_attributes_for :challenge_judgements

  validates :assignment_id, uniqueness: { scope: :entry_id,
                                    message: 'Scorecard already exists' }

  def team
    entry.team
  end

  def total_score
    score = 0
    challenge_judgements.each do |judgement|
      return nil if judgement.score.nil?
      score += judgement.score
    end
    score
  end

  def display_score
    score = total_score
    return 'Scorecard Incomplete' if score.nil?
    score
  end

  def self.update_scorecards!(judge_assignment, challenge)
    check_for_missing_scorecards!(judge_assignment, challenge)
    check_for_missing_judgements(judge_assignment, challenge)
  end

  def self.check_for_missing_scorecards!(judge_assignment, challenge)
    scorecards_entry_ids = judge_assignment.challenge_scorecards.pluck(:entry_id)
    all_entries_ids = challenge.entries.pluck(:id)
    needed = all_entries_ids - scorecards_entry_ids
    needed.each do |entry_id|
      judge_assignment.challenge_scorecards.create(entry_id: entry_id)
    end
  end

  def self.check_for_missing_judgements(judge_assignment, challenge)
    challenge_criteria_ids = challenge.challenge_criteria.pluck(:id)
    judge_assignment.challenge_scorecards.each do |scorecard|
      score_card_criteria_ids = scorecard.challenge_judgements.pluck(:challenge_criterion_id)
      needed = challenge_criteria_ids - score_card_criteria_ids
      needed.each do |criterion_id|
        scorecard.challenge_judgements.create(challenge_criterion_id: criterion_id)
      end
    end
  end
end
