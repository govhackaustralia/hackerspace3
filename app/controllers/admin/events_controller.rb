class Admin::EventsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @connections = @competition.connection_events
    @attending_connection_registrations_count = @competition.connection_registrations.attending.count
    @competition_events = @competition.competition_events
    @attending_competition_registrations_count = @competition.competition_registrations.attending.count
    @award_events = @competition.award_events
    @attending_awards_registrations_count = @competition.award_registrations.attending.count
  end

  private

  def check_for_privileges
    @competition = Competition.find params[:competition_id]
    return if current_user.event_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
