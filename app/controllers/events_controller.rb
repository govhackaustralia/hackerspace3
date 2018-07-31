class EventsController < ApplicationController
  def index
    @events = if params[:category_type].nil?
                Competition.current.events
              else
                Competition.current.events.where(category_type: params[:category_type])
              end
  end

  def show
    @event = Event.find_by_identifier(params[:identifier])
    @event_partner = @event.event_partner
    @region = @event.region
    @sponsorship_types = @region.sponsorship_types.distinct.order(order: :asc)
    return unless user_signed_in?
    @registration = Registration.find_by(event: @event, assignment: current_user.event_assignment)
  end
end
