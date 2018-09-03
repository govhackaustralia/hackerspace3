class Admin::TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @competition = Competition.current
    @teams = @competition.teams
    @id_teams_projects = Team.id_teams_projects(@teams.pluck(:id))
  end

  def show
    @team = Team.find(params[:id])
    @project = @team.current_project
    @projects = @team.projects
    @event = @team.event
    @region = @team.region
    @competition = @team.competition
    @checkpoints = @competition.checkpoints.order(:end_time)
    @available_regional_challenges = @team.available_challenges(REGIONAL)
    @available_national_challenges = @team.available_challenges(NATIONAL)
  end

  def update
    @team = Team.find(params[:id])
    @project = Project.find(params[:project_id])
    @team.update(project_id: @project.id)
    if @team.save
      flash[:notice] = 'Current Project Updated'
    else
      flash[:alert] = @team.errors.full_messages.to_sentence
    end
    redirect_to admin_team_project_path(@team, @project)
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
