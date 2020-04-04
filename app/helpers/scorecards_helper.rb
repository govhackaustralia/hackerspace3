module ScorecardsHelper
  def challenge_title_required?(score)
    return false if score.scorecard_id == @scorecard.id

    if @challenge_scorecard.nil? || @challenge_scorecard.id != score.scorecard_id
      @challenge_scorecard = score.scorecard
      return true
    end
    false
  end

  def show_challenge_score_stuff?
    @judge.present? && @competition.in_challenge_judging_window?(LAST_TIME_ZONE)
  end

  def show_peoples_choice_stuff?
    @peoples_assignment.present? && @competition.in_peoples_judging_window?(LAST_TIME_ZONE)
  end
end
