class EventsController < ApplicationController
  def index
    if params[:category_type].nil?
      @events = Competition.current.events
    else
      @events = Competition.current.events.where(category_type: params[:category_type])
    end
  end

  def show
    @event = Event.find(params[:id])
    @region = @event.region
    return unless user_signed_in?
    @registration = Registration.find_by(event: @event, assignment: current_user.event_assignment)
  end
end
