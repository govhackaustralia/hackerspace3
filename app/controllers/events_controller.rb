class EventsController < ApplicationController
  def index
    @events = retrieve_events
    respond_to do |format|
      format.html
      format.csv { send_data @events.to_csv }
    end
  end

  def show
    @event = Event.find_by(identifier: params[:identifier])
    if @event.published || (user_signed_in? && current_user.event_privileges?)
      show_event
    else
      flash[:alert] = 'This event has not been published.'
      redirect_to root_path
    end
  end

  private

  def retrieve_events
    if params[:event_type].present?
      Competition.current.events.published.where(event_type: params[:event_type]).order(start_time: :asc, name: :asc).preload(:region)
    else
      Competition.current.events.published.order(start_time: :asc, name: :asc).preload(:region)
    end
  end

  def show_event
    @competition = @event.competition
    @event_partner = @event.event_partner
    @region = @event.region
    @sponsorship_types = @region.sponsorship_types.distinct.order(order: :asc)
    set_signed_in_user_vars if user_signed_in?
  end

  def set_signed_in_user_vars
    @user = current_user
    @registration = Registration.find_by(event: @event, assignment: @user.event_assignment)
    @team = @event.teams.new
  end
end
