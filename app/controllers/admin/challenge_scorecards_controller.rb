class Admin::ChallengeScorecardsController < ApplicationController
  def index
    @user = current_user
    if params[:challenge_id].present?
      @challenge = Challenge.find(params[:challenge_id])
    else
      @challenges = @user.challenges_judging
    end
  end

  def edit
    @scorecard = ChallengeScorecard.find(params[:id])
    @judgements = @scorecard.challenge_judgements
  end

  def update
    @scorecard = ChallengeScorecard.find(params[:id])
    @judgements = @scorecard.challenge_judgements
    if update_judgements
      flash[:notice] = 'Scorecard Updated'
      redirect_to admin_challenge_scorecards_path(challenge_id: @scorecard.entry.challenge_id)
    else
      flash[:alert] = 'Error: One or more scores missing or out of range'
      render :edit
    end
  end

  private

  def update_judgements
    success = true
    @judgements.each do |judgement|
      new_score = params[:judgements][judgement.id.to_s][:score].to_i
      if validate_new_score(new_score)
        judgement.update(score: new_score)
      else
        success = false
      end
    end
    success
  end

  def validate_new_score(new_score)
    return false if new_score.blank?
    return false unless (MIN_SCORE..MAX_SCORE).cover?(new_score)
    true
  end
end
