class Admin::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @team = Team.find params[:team_id]
    @current_project = @team.current_project
    @projects = @team.projects.order created_at: :desc
  end

  def show
    @project = Project.find params[:id]
    @user = @project.user
    @team = @project.team
    @current_project = @team.current_project
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
