class TeamManagement::TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_team_privileges!

  def show
    @current_project = @team.current_project
    @event = @team.event
    @region = @event.region
  end

  def edit
    @events = @team.member_competition_events
  end

  def update
    @team.update(team_params) unless params[:team].blank?
    if @team.save
      handle_update_redirect
    else
      @events = @team.member_competition_events
      flash[:alert] = @team.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  # IMPROVEMENT - Multiple move up to ApplicationController
  def check_user_team_privileges!
    @team = Team.find params[:id]
    @competition = @team.competition
    return if @team.permission?(current_user) && @competition.in_window?(@team.time_zone)

    check_team_permission
  end

  def check_team_permission
    if @team.permission?(current_user)
      flash[:notice] = 'No team editing at this time.'
      redirect_to project_path(@team.current_project.identifier)
    else
      flash[:notice] = 'You do not have access permissions for this team.'
      redirect_to root_path
    end
  end

  # IMPROVEMENT: Break up into separate public controller methods.
  def handle_update_redirect
    if params[:thumbnail].present?
      flash[:notice] = 'Thumbnail Updated'
      render :edit, thumbnail: true
    elsif params[:high_res_image].present?
      flash[:notice] = 'High Resolution Image Updated'
      render :edit, high_res_image: true
    else
      flash[:notice] = 'Team Details Upated'
      redirect_to team_management_team_path @team
    end
  end

  def team_params
    params.require(:team).permit(
      :event_id,
      :thumbnail,
      :high_res_image,
      :youth_team
    )
  end
end
