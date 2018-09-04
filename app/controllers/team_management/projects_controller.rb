class TeamManagement::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_team_privileges!

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = @team.projects.new(project_params)
    @project.user = current_user
    if @project.save
      handle_successful_save
    else
      flash[:alert] = @project.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def project_params
    params.require(:project).permit(:team_name, :description, :data_story,
                                    :source_code_url, :video_url, :homepage_url)
  end

  def handle_successful_save
    @team.update(project_id: @project.id)
    flash[:notice] = 'Team Project updated'
    redirect_to team_management_team_path(@team)
  end

  def check_user_team_privileges!
    @team = Team.find(params[:team_id])
    return if @team.permission?(current_user)
    flash[:notice] = 'You do not have access permissions for this team.'
    redirect_to root_path
  end
end
