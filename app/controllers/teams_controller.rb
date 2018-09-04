class TeamsController < ApplicationController
  def index
    @competition = Competition.current
    @teams = @competition.teams.where(published: true)
    @id_teams_projects = Team.id_teams_projects(@teams.pluck(:id))
    @attending_events = current_user.competition_events_attending(@competition) if user_signed_in?
    respond_to do |format|
      format.html
      format.csv { send_data @teams.to_csv }
    end
  end

  def show
    @team = Team.find(params[:id])
    @current_project = @team.current_project
    @checkpoints = @team.event.competition.checkpoints.order(:end_time)
    user_signed_in_records if user_signed_in?
  end

  def new
    if user_signed_in?
      @competition = Competition.current
      @team = Team.new
      @events = current_user.competition_events_attending(@competition)
      if @events.empty?
        flash[:alert] = 'To create a new team, first register for a competition event.'
        redirect_to root_path
      else
        flash[:alert] = 'To create a now team, first sign in.'
        redirect_to root_path
      end
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
    @team.projects.create(team_name: "Team #{@team.id}", user: current_user)
    flash[:notice] = 'New Team Project Created'
    redirect_to team_management_team_path(@team)
  end

  def user_signed_in_records
    @user = current_user
    @peoples_scorecard = PeoplesScorecard.find_by(assignment: @user.event_assignment, team: @team)
    @favourite = Favourite.find_by(assignment: @user.event_assignment, team: @team)
  end
end
