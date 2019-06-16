class EventsController < ApplicationController
  def index
    retrieve_events
    respond_to do |format|
      format.html
      format.csv { send_data @events.to_csv @competition }
    end
  end

  def show
    @event = Event.find_by identifier: params[:identifier]
    @competition = @event.competition
    if @event.published || (user_signed_in? && current_user.event_privileges?(@competition))
      show_event
    else
      flash[:alert] = 'This event has not been published.'
      redirect_to root_path
    end
  end

  private

  def retrieve_events
    @events = @competition.events.published.preload(:region).order start_time: :asc, name: :asc
    retrieve_future_events
    retrive_past_events
  end

  def retrieve_future_events
    @future_connections = @events.connections.future
    @future_locations = @events.locations.future
    @future_remotes = @events.remotes.future
    @future_awards = @events.awards.future
  end

  def retrive_past_events
    @past_connections = @events.connections.past
    @past_competitions = @events.competitions.past
    @past_awards = @events.awards.past
  end

  def show_event
    @event_partner = @event.event_partner
    @region = @event.region
    @sponsorship_types = @region.sponsorship_types.distinct.order order: :asc
    set_signed_in_user_vars if user_signed_in?
  end

  def set_signed_in_user_vars
    @user = current_user
    @registration = Registration.find_by(
      event: @event,
      assignment: @user.event_assignment(@competition)
    )
    @team = @event.teams.new
  end
end
