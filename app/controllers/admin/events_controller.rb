class Admin::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @competition = Competition.current
    @connections = @competition.events.where(event_type: CONNECTION_EVENT)
    @connections_registrations = Registration.where(event_id: @connections.pluck(:id))
    @competition_events = @competition.events.where(event_type: COMPETITION_EVENT)
    @competition_registrations = Registration.where(event_id: @competition_events.pluck(:id))
    @award_events = @competition.events.where(event_type: AWARD_EVENT)
    @award_registrations = Registration.where(event_id: @award_events.pluck(:id))
  end

  private

  def check_for_privileges
    return if current_user.event_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
