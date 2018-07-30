class EventsController < ApplicationController
  def index
    @events = Competition.current.events
  end

  def show
    @event = Event.find(params[:id])
    @region = @event.region
    @registration = Registration.find_by(event: @event, assignment: current_user.event_assignment)
  end
end
