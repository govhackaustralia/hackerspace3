class EventsController < ApplicationController
  def index
    @events = Competition.current.events
  end

  def show
    @event = Event.find(params[:id])
    return unless @event.registered(current_user)
    @attendance = current_user.attendances.find_by(event: @event)
  end
end
