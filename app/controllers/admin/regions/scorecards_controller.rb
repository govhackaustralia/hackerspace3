class Admin::Regions::ScorecardsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  require 'descriptive_statistics'

  def index
    @competition = Competition.current
    @project_judging_total = @competition.score_total PROJECT
    @region = Region.find params[:region_id]
    retrieve_helpers
  end

  private

  def check_for_privileges
    return if current_user.region_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def retrieve_helpers
    @teams = @region.teams.published
    @projects = @region.published_projects_by_name.preload(:event)
    @region_scorecard_helper = Scorecard.region_scorecard_helper(@teams, PROJECT, params[:include_judges] == true.to_s)
  end
end
