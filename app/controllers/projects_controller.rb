class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @team = Team.find(params[:team_id])
    @project = Project.find(params[:id])
  end

  def update
    @team = Team.find(params[:team_id])
    @project = @team.projects.new(project_params)
    if @project.save
      handle_successful_save
    else
      flash[:notice] = @project.errors.full_messages.to_sentence
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
    redirect_to team_path(@team)
  end
end
