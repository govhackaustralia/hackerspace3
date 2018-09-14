class Admin::Regions::ScorecardsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  require 'descriptive_statistics'

  def index
    @competition = Competition.current
    @project_judging_total = @competition.score_total PROJECT
    @region = Region.find(params[:region_id])
    @teams = @region.teams.where(published: true)
    @id_teams_projects = Team.id_teams_projects(@teams)
    @projects = Team.projects_by_name(@id_teams_projects)
    @region_scorecard_helper = Scorecard.region_scorecard_helper(@teams, PROJECT)
  end

  private

  def check_for_privileges
    return if current_user.region_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
