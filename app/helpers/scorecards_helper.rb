module ScorecardsHelper
  def challenge_title_required?(judgment)
    return false if judgment.scorecard_id == @scorecard.id
    if @challenge_scorecard.nil? || @challenge_scorecard.id != judgment.scorecard_id
      @challenge_scorecard = judgment.scorecard
      return true
    end
    false
  end
end
