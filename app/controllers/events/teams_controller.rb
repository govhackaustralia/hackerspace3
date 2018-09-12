class Events::TeamsController < ApplicationController
  def index
    @event = Event.find_by(identifier: params[:event_identifier])
    @competition = @event.competition
    @teams = @event.teams.where(published: true)
    @id_teams_projects = Team.id_teams_projects(@teams)
    @judgeable_assignment = current_user.judgeable_assignment if user_signed_in? && @competition.in_judging_window?(LAST_TIME_ZONE)
    @project_judging = @judgeable_assignment.judgeable_scores(@teams) if @judgeable_assignment.present?
    @projects = Team.projects_by_name(@id_teams_projects)
  end
end
