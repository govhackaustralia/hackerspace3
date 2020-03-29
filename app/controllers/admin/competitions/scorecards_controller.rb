class Admin::Competitions::ScorecardsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @project_judging_total = @competition.score_total PROJECT
    @teams = @competition.teams.published
    @projects = @competition.published_projects_by_name.preload :event
    @region_scorecard_helper = Scorecard.region_scorecard_helper(
      @competition, @teams, PROJECT, params[:include_judges] == true.to_s
    )
    handle_index
  end

  private

  def handle_index
    respond_to do |format|
      format.html
      format.csv { send_data PeoplesJudgesReport.new(@competition).to_csv }
    end
  end

  def check_for_privileges
    @competition = Competition.find params[:competition_id]
    return if current_user.admin_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
