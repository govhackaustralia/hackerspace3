class PeoplesScorecardsController < ApplicationController
  before_action :authenticate_user!

  def new
    @team = Team.find(params[:team_id])
    @peoples_scorecard = @team.peoples_scorecards.create(assignment: current_user.event_assignment)
    @judgements = @peoples_scorecard.update_judgements
  end

  def edit
    @peoples_scorecard = PeoplesScorecard.find(params[:id])
    @judgements = @peoples_scorecard.update_judgements
    @team = @peoples_scorecard.team
  end

  def update
    retrieve_update_vars
    if process_judgements
      flash[:notice] = 'Peoples\'s Choice Judgement Saved'
      redirect_to project_path(@team.current_project)
    else
      flash[:alert] = 'Error: One or more scores missing or out of range'
      render :new
    end
  end

  private

  def peoples_scorecard_params
    params.require(:peoples_scorecard).permit(:assignment_id, :team_id)
  end

  def retrieve_update_vars
    @peoples_scorecard = PeoplesScorecard.find(params[:id])
    @judgements = @peoples_scorecard.peoples_judgements
    @team = @peoples_scorecard.team
  end

  def process_judgements
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
