class Admin::TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @competition = Competition.current
    @teams = @competition.teams
    @id_teams_projects = Team.id_teams_projects(@teams)
    @projects = Team.projects_by_name(@id_teams_projects)
    handle_index
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
    if params[:project_id].present?
      handle_update_project
    elsif params[:published].present?
      handle_update_published
    end
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def handle_index
    respond_to do |format|
      format.html
      if params[:category] == 'members'
        format.csv { send_data User.all_members_to_csv }
      else
        format.csv { send_data User.published_teams_to_csv }
      end
    end
  end

  def handle_update_project
    @project = Project.find(params[:project_id])
    @team.update(current_project: @project)
    flash[:notice] = 'Current Project Updated'
    redirect_to admin_team_project_path(@team, @project)
  end

  def handle_update_published
    @team.update(published: params[:published])
    flash[:notice] = 'Team Updated'
    redirect_to admin_team_path(@team)
  end
end
