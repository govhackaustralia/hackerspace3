class Admin::ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @team = Team.find params[:team_id]
    @current_project = @team.current_project
    @projects = @team.projects.order created_at: :desc
    check_for_privileges @team.competition
  end

  def show
    @project = Project.find params[:id]
    @user = @project.user
    @team = @project.team
    @current_project = @team.current_project
    check_for_privileges @team.competition
  end

  private

  def check_for_privileges(competition)
    return if current_user.admin_privileges? competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
