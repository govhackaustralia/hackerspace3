class TeamsController < ApplicationController
  def new
    if user_signed_in?
      @competition = Competition.current
      @team = Team.new
      @events = current_user.competition_events_attending(@competition)
      if @events.empty?
        flash[:alert] = 'To create a new team, first register for a competition event.'
        redirect_to root_path
      end
    else
      flash[:alert] = 'To create a now team, first sign in.'
      redirect_to root_path
    end
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

  private

  def team_params
    params.require(:team).permit(:event_id, :youth_team)
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
