class TeamsController < ApplicationController
  def index
    @competition = Competition.current
    @teams = @competition.teams.where(published: true)
    @id_teams_projects = Team.id_teams_projects(@teams.pluck(:id))
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

  private

  def user_signed_in_records
    @user = current_user
    @peoples_scorecard = PeoplesScorecard.find_by(assignment: @user.event_assignment, team: @team)
    @favourite = Favourite.find_by(assignment: @user.event_assignment, team: @team)
  end
end
