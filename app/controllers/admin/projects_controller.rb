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

  def edit
    @project = Project.find params[:id]
    @namespace = :admin
  end

  def update
    update_project
    if @project.save
      flash[:notice] = 'Team Project Saved'
      redirect_to admin_team_project_path @project.team, @project
    else
      @namespace = :admin
      flash[:alert] = @project.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def check_for_privileges!
    @team = Team.find params[:team_id]
    @competition = @team.competition
    return if current_user.admin_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def project_params
    params.require(:project).permit(
      %i[
        team_name description data_story source_code_url
        video_url homepage_url project_name
      ]
    )
  end

  def update_project
    @project = @team.current_project.dup
    @project.update project_params
    @project.user = current_user
  end
end
