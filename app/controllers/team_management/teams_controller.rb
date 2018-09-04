class TeamManagement::TeamsController < ApplicationController
  before_action :authenticate_user!

  def show
    @team = Team.find(params[:id])
    @current_project = @team.current_project
    @event = @team.event
    @competition = @event.competition
  end

  def new
    @competition = Competition.current
    @team = Team.new
    @events = current_user.competition_events_attending(@competition)
  end

  def edit
    @team = Team.find(params[:id])
    @events = @team.member_competition_events
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      handle_team_save
    else
      flash[:alert] = @team.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    update_team
    if @team.save
      handle_update_redirect
    else
      flash[:alert] = @team.errors.full_messages.to_sentence
      render :new
    end
  end

  private

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

  def update_team
    @team = Team.find(params[:id])
    @team.update(team_params) unless params[:team].blank?
  end

  def handle_team_save
    @team.assign_leader(current_user)
    @team.projects.create(team_name: "Team #{@team.id}", user: current_user)
    flash[:notice] = 'New Team Project Created'
    redirect_to team_management_team_path(@team)
  end

  def team_params
    params.require(:team).permit(:event_id, :published, :thumbnail, :high_res_image, :youth_team)
  end
end
