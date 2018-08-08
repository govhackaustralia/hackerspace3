class TeamsController < ApplicationController
  def show
    @team = Team.find(params[:id])
    @current_project = @team.current_project
    @event = @team.event
  end

  def new
    @event = Event.find_by(identifier: params[:event_identifier])
    @team = @event.teams.new
  end

  def edit
    @team = Team.find(params[:id])
    @events = Event.where(event_type: COMPETITION_EVENT, competition: Competition.current)
  end

  def create
    @event = Event.find(params[:event_identifier])
    @team = @event.teams.new
    if @team.save
      handle_team_save
    else
      @team.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @team = Team.find(params[:id])
    @team.update(team_params)
    if @team.save
      flash[:notice] = 'Team Participating Event Upated'
      redirect_to team_path(@team)
    else
      @team.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def handle_team_save
    @team.assign_leader(current_user)
    @team.projects.create(team_name: "Team #{@team.id}")
    flash[:notice] = 'New Team Project Created'
    redirect_to team_path(@team)
  end

  def team_params
    params.require(:team).permit(:event_id)
  end
end
