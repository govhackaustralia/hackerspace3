class EventsController < ApplicationController
  def index
    @events = Competition.current.events
  end

  def show
    @event = Event.find(params[:id])
    @region = @event.region
    return unless user_signed_in? && @event.registered(current_user)
    @registration = current_user.registrations.find_by(event: @event)
  end
end
