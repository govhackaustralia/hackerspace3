class TeamsController < ApplicationController
  before_action :authenticate_user!

  def new
    @competition = Competition.current
    if @competition.in_window? LAST_TIME_ZONE
      handle_new
    else
      flash[:alert] = 'The competition is now closed.'
      redirect_to projects_path
    end
  end

  def create
    @team = Team.new team_params
    @competition = @team.competition
    @events = current_user.participating_competition_events.where competition: @competition
    if @competition.in_window? @team.time_zone
      create_team
    else
      flash[:alert] = "The competition has closed in region #{@team.region.name}"
      render :new
    end
  end

  private

  def team_params
    params.require(:team).permit :event_id, :youth_team
  end

  def handle_new
    @team = Team.new
    @events = current_user.participating_competition_events & Competition.current.events.competitions
    return unless @events.empty?

    flash[:alert] = 'To create a new team, first register for a competition event.'
    redirect_to competition_events_path
  end

  def create_team
    if @team.save
      handle_team_save
    else
      flash[:alert] = @team.errors.full_messages.to_sentence
      render :new
    end
  end

  def handle_team_save
    @team.assign_leader(current_user)
    @team.projects.create(team_name: "Team #{@team.id}",
                          project_name: "Project #{@team.id}",
                          user: current_user)
    flash[:notice] = 'New Team Project Created'
    redirect_to team_management_team_path(@team)
  end
end
