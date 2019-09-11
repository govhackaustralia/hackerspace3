class Admin::ProjectsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges!

  def index
    @current_project = @team.current_project
    @projects = @team.projects.order(created_at: :desc).preload :user
  end

  def show
    @project = Project.find params[:id]
    @user = @project.user
    @team = @project.team
    @current_project = @team.current_project
  end

  private

  def check_for_privileges!
    @team = Team.find params[:team_id]
    @competition = @team.competition
    return if current_user.admin_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
