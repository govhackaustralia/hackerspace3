class TeamsController < ApplicationController
  def index
    @competition = Competition.current
    @teams = @competition.teams.where(published: true)
  end

  def show
    @team = Team.find(params[:id])
    @current_project = @team.current_project
    @checkpoints = @team.event.competition.checkpoints.order(:end_time)
    return unless user_signed_in?
    @user = current_user
    @peoples_scorecard = PeoplesScorecard.find_by(assignment: @user.event_assignment, team: @team)
  end
end
