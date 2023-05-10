# frozen_string_literal: true

class Admin::TeamsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges!
  before_action :retrieve_team, except: :index

  def index
    @projects = @competition.projects_by_name.preload(:event, :team)
    handle_index
  end

  def show
    @project = @team.current_project
    @projects = @team.projects
    @event = @team.event
    @region = @team.region
    @checkpoints = @competition.checkpoints.order :end_time
    @available_regional_challenges = @team.available_challenges REGIONAL
    @available_national_challenges = @team.available_challenges NATIONAL
  end

  def update_version
    @project = Project.find params[:project_id]
    @team.update current_project: @project
    flash[:notice] = 'Current Project Version Updated'
    redirect_to admin_team_project_path @team, @project
  end

  def update_published
    if @team.update published: !@team.published
      flash[:notice] = "Team #{'un' unless @team.published}published"
    else
      flash[:error] = @team.errors.full_messages.to_sentence
    end
    redirect_to admin_competition_team_path @competition, @team
  end

  private

  def check_for_privileges!
    @competition = Competition.find params[:competition_id]
    return if current_user.admin_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def retrieve_team
    @team = Team.find params[:id]
  end

  def handle_index
    respond_to do |format|
      format.html
      handle_csv(format)
    end
  end

  def handle_csv(format)
    output = case params[:category]
    when 'members'
      TeamMemberReport.new(@competition).to_csv
    when 'entries'
      TeamEntryReport.new(@competition).to_csv
    else
      PublishedTeamMemberReport.new(@competition).to_csv
    end
    format.csv { send_data output }
  end
end
