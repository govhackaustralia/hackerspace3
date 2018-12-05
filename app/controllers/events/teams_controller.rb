class Events::TeamsController < ApplicationController
  def index
    @event = Event.find_by(identifier: params[:event_identifier])
    @competition = @event.competition
    @teams = @event.teams.where(published: true)
    @id_teams_projects = Team.id_teams_projects(@teams)
    @projects = Team.projects_by_name(@id_teams_projects)
    user_judging if user_signed_in?
  end

  private

  def user_judging
    @peoples_assignment = current_user.peoples_assignment
    return unless @peoples_assignment.present? && helpers.in_peoples_judging_window?(LAST_TIME_ZONE)
    return unless (@judgeable_assignment = current_user.judgeable_assignment).present?

    @project_judging = @judgeable_assignment.judgeable_scores(@teams)
    @project_judging_total = @competition.score_total PROJECT
  end
end
