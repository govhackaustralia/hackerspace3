class Admin::Teams::ScorecardsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @team = Team.find(params[:team_id])
    @project = @team.current_project
    @region = @team.region
    @competition = @team.competition
    retrieve_scorecard_info
  end

  def update
    @scorecard = Scorecard.find(params[:id])
    @scorecard.update(included: !@scorecard.included)
    redirect_to admin_team_scorecards_path(@scorecard.judgeable, popup: true, include_judges: params[:include_judges])
  end

  def destroy
    @scorecard = Scorecard.find(params[:id])
    @scorecard.destroy
    flash[:notice] = 'Scorecard Deleted'
    redirect_to admin_team_scorecards_path(@scorecard.judgeable, popup: true, include_judges: params[:include_judges])
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def retrieve_scorecard_info
    @scorecards = participant_scorecards
    @project_criteria = @competition.project_criteria.order(:id)
    @team_scorecard_helper = Scorecard.team_scorecard_helper(@scorecards)
  end

  # Retrieves all a team's scorecards and removes those of the judges if
  # params require.
  # ENHANCEMENT: Move judge move logic in active record associations.
  # Only need to find judges for that team.
  def participant_scorecards
    all_scorecards = @team.scorecards.order(:assignment_id).preload(:assignment_scorecards, :assignment_judgments)
    return all_scorecards if params[:include_judges] == true.to_s

    judge_user_ids = Assignment.where(title: JUDGE).pluck(:user_id)
    judge_assignment_ids = Assignment.where(title: EVENT_ASSIGNMENTS, user_id: judge_user_ids).pluck(:id)
    judge_scorecards = Scorecard.where(assignment_id: judge_assignment_ids)
    all_scorecards - judge_scorecards
  end
end
