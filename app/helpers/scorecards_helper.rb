module ScorecardsHelper
  def challenge_title_required?(score)
    return false if score.header_id == @header.id

    if @challenge_header.nil? || @challenge_header.id != score.header_id
      @challenge_header = score.header
      return true
    end
    false
  end

  def show_challenge_score_stuff?
    @judge.present? && @competition.in_challenge_judging_window?(COMP_TIME_ZONE)
  end

  def show_peoples_choice_stuff?
    @peoples_assignment.present? && @competition.in_peoples_judging_window?(COMP_TIME_ZONE)
  end
end
