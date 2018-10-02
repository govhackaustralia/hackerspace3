module ScorecardsHelper
  def challenge_title_required?(judgment)
    return false if judgment.scorecard_id == @scorecard.id
    if @challenge_scorecard.nil? || @challenge_scorecard.id != judgment.scorecard_id
      @challenge_scorecard = judgment.scorecard
      return true
    end
    false
  end

  def show_challenge_judgment_stuff?
    @judge.present? && @competition.in_challenge_judging_window?(LAST_TIME_ZONE)
  end

  def show_peoples_choice_stuff?
    @peoples_assignment.present? && @competition.in_peoples_judging_window?(LAST_TIME_ZONE)
  end
end
