class EventsController < ApplicationController
  def index
    @events = if params[:event_type].present?
                Competition.current.events.where(event_type: params[:event_type]).order(start_time: :asc)
              else
                Competition.current.events.order(start_time: :asc)
              end
  end

  def show
    @event = Event.find_by(identifier: params[:identifier])
    @event_partner = @event.event_partner
    @region = @event.region
    @sponsorship_types = @region.sponsorship_types.distinct.order(order: :asc)
    return unless user_signed_in?
    @user = current_user
    @registration = Registration.find_by(event: @event, assignment: @user.event_assignment)
  end
end
