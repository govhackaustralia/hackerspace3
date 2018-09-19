class Admin::Teams::ScorecardsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @team = Team.find(params[:team_id])
    @project = @team.current_project
    @region = @team.region
    @competition = @team.competition
    @scorecards = Scorecard.participant_scorecards(@team)
    @project_criteria = @competition.criteria.where(category: PROJECT).order(:id)
    @team_scorecard_helper = Scorecard.team_scorecard_helper(@scorecards)
    assignments = Assignment.where(id: @scorecards.pluck(:assignment_id))
    @assignment_scorecard_helper = Scorecard.assignment_scorecard_helper(assignments)
  end

  def update
    @scorecard = Scorecard.find(params[:id])
    @scorecard.update(included: !@scorecard.included)
    redirect_to admin_team_scorecards_path(@scorecard.judgeable, popup: true)
  end

  def destroy
    @scorecard = Scorecard.find(params[:id])
    @scorecard.destroy
    flash[:notice] = 'Scorecard Deleted'
    redirect_to admin_team_scorecards_path(@scorecard.judgeable, popup: true)
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
