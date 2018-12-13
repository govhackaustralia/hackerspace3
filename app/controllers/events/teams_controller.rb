class Events::TeamsController < ApplicationController
  def index
    @event = Event.find_by(identifier: params[:event_identifier])
    @competition = @event.competition
    @teams = @event.published_teams
    @projects = @event.published_projects_by_name.preload(:event)
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
