class Events::TeamsController < ApplicationController
  def index
    @event = Event.find_by(identifier: params[:event_identifier])
    @competition = @event.competition
    @teams = @event.teams.where(published: true)
    @id_teams_projects = Team.id_teams_projects(@teams)
    @projects = Team.projects_by_name(@id_teams_projects)
    return unless user_signed_in?

    @peoples_assignment = current_user.peoples_assignment
    if @peoples_assignment.present? && @competition.in_peoples_judging_window?(LAST_TIME_ZONE)
      if (@judgeable_assignment = current_user.judgeable_assignment).present?
        @project_judging = @judgeable_assignment.judgeable_scores(@teams)
        @project_judging_total = @competition.score_total PROJECT
      end
    end
  end
end
