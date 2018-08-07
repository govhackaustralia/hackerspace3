class TeamProjectsController < ApplicationController
  def show
    @team_project = TeamProject.find(params[:id])
    @current_version = @team_project.current_version
  end

  def new
    @event = Event.find_by(identifier: params[:event_identifier])
    @team_project = @event.team_projects.new
    @team_project.team_project_versions.build
  end

  def create
    @event = Event.find(params[:event_identifier])
    @team_project = @event.team_projects.new(team_project_params)
    if @team_project.save
      @team_project.assign_leader(current_user)
      flash[:notice] = 'New Team Project Created'
      redirect_to team_project_path(@team_project)
    else
      @team_project.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def team_project_params
    params.require(:team_project).permit(team_project_version_attributes:
      %i[id team_name description data_story source_code_url
         video_url homepage_url])
  end
end
