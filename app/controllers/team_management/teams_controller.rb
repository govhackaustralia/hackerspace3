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
      flash[:alert] = @team.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def check_user_team_privileges!
    @team = Team.find(params[:id])
    @competition = @team.competition
    return if @team.permission?(current_user) && @competition.in_competition_window?(@team.time_zone)
    unless @team.permission?(current_user)
      flash[:notice] = 'You do not have access permissions for this team.'
      redirect_to root_path
    else
      flash[:notice] = 'The competition has closed.'
      redirect_to project_path(@team.current_project.identifier)
    end
  end

  def handle_update_redirect
    if params[:thumbnail].present?
      flash[:notice] = 'Thumbnail Updated'
      render :edit, thumbnail: true
    elsif params[:high_res_image].present?
      flash[:notice] = 'High Resolution Image Updated'
      render :edit, high_res_image: true
    else
      flash[:notice] = 'Team Details Upated'
      redirect_to team_management_team_path(@team)
    end
  end

  def team_params
    params.require(:team).permit(:event_id, :thumbnail, :high_res_image, :youth_team)
  end
end
