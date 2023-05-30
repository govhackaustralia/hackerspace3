# frozen_string_literal: true

class Admin::Regions::ScorecardsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @project_judging_total = @competition.score_total PROJECT
    retrieve_helpers
  end

  private

  def check_for_privileges
    @region = @competition.regions.find_by_identifier params[:region_id]
    @competition = @region.competition
    return if current_user.region_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def retrieve_helpers
    @teams = @region.teams.published
    @projects = @region.published_projects_by_name.preload :event
    @region_helper = Header.region_helper(
      @competition, @teams, PROJECT, params[:include_judges] == true.to_s,
    )
  end
end
