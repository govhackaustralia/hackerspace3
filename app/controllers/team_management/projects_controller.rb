class TeamManagement::ProjectsController < TeamManagement::TeamsController
  before_action :check_in_form_or_comp_window!

  def create
    update
  end

  def edit
    @project = Project.find params[:id]
  end

  def update
    update_project
    if @project.save
      flash[:notice] = 'Team Project Saved'
      redirect_to edit_team_management_team_project_path @project.team, @project
    else
      flash[:alert] = @project.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def project_params
    params.require(:project).permit(*permitied_attributes)
  end

  def permitied_attributes
    return [:team_name] unless @competition.in_comp_window? @time_zone

    %i[team_name description data_story source_code_url
       video_url homepage_url project_name]
  end

  def update_project
    @project = @team.current_project.dup
    @project.update project_params
    @project.user = current_user
  end
end
