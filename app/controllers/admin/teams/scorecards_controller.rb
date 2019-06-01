class Admin::Teams::ScorecardsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  require 'descriptive_statistics'

  def index
    @project = @team.current_project
    @region = @team.region
    retrieve_scorecard_info
  end

  def update
    @scorecard = Scorecard.find params[:id]
    @scorecard.update included: !@scorecard.included
    redirect_to admin_team_scorecards_path @scorecard.judgeable, popup: true, include_judges: params[:include_judges]
  end

  def destroy
    @scorecard = Scorecard.find params[:id]
    @scorecard.destroy
    flash[:notice] = 'Scorecard Deleted'
    redirect_to admin_team_scorecards_path @scorecard.judgeable, popup: true, include_judges: params[:include_judges]
  end

  private

  def check_for_privileges
    @team = Team.find params[:team_id]
    return if current_user.admin_privileges?(@competition = @team.competition)

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def retrieve_scorecard_info
    @scorecards = participant_scorecards
    @project_criteria = @competition.project_criteria.order(:id)
  end

  # Retrieves all a team's scorecards and removes those of the judges if
  # params require.
  def participant_scorecards
    all_scorecards = @team.scorecards.order(:assignment_id).preload :assignment_scorecards, :assignment_judgments, :judgments
    return all_scorecards if params[:include_judges] == true.to_s

    all_scorecards - @team.judge_scorecards.where(judgeable: @team)
  end
end
