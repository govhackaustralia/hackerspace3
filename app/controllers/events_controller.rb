class EventsController < ApplicationController
  def index
    @events = Competition.current.events
  end

  def show
    @event = Event.find(params[:id])
  end
end
