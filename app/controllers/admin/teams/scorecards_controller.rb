class Admin::Teams::ScorecardsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @project = @team.current_project
    @region = @team.region
    retrieve_scorecard_info
  end

  def update
    @header= Header.find params[:id]
    @header.update included: !@header.included
    redirect_to admin_team_scorecards_path @header.scoreable, popup: true, include_judges: params[:include_judges]
  end

  def destroy
    @header= Header.find params[:id]
    @header.destroy
    flash[:notice] = 'Scorecard Deleted'
    redirect_to admin_team_scorecards_path @header.scoreable, popup: true, include_judges: params[:include_judges]
  end

  private

  def check_for_privileges
    @team = Team.find params[:team_id]
    return if current_user.admin_privileges?(@competition = @team.competition)

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def retrieve_scorecard_info
    @headers = participant_headers
    @project_criteria = @competition.project_criteria.order(:id)
  end

  # Retrieves all a team's scorecards and removes those of the judges if
  # params require.
  def participant_headers
    all_headers = @team.headers.order(:assignment_id).preload :assignment_headers, :assignment_scores, :scores
    return all_headers if params[:include_judges] == true.to_s

    all_headers - @team.judge_headers.where(scoreable: @team)
  end
end
