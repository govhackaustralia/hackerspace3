class EventsController < ApplicationController
  before_action :check_event_published!, only: :show

  def index
    retrieve_events
    respond_to do |format|
      format.html
      format.csv { send_data @events.to_csv @competition }
    end
  end

  def show
    @event_partners = @event.event_partners
    @region = @event.region
    @sponsorship_types = @region.sponsorship_types.distinct.order order: :asc
    set_signed_in_user_vars if user_signed_in?
  end

  private

  def check_event_published!
    @event = Event.find_by identifier: params[:identifier]
    @competition = @event.competition
    return if @event.published

    redirect_to root_path, alert: 'This event has not been published.'
  end

  def retrieve_events
    @events = @competition.events.published
      .preload(:region)
      .order(start_time: :asc, name: :asc)
    retrieve_future_events
    retrive_past_events
  end

  def retrieve_future_events
    @future_connections = @events.connections.future
    @future_mini_confs = @events.mini_confs.future
    @future_locations = @events.locations.future
    @future_remotes = @events.remotes.future
    @future_awards = @events.awards.future
  end

  def retrive_past_events
    @past_connections = @events.connections.past
    @past_mini_confs = @events.mini_confs.past
    @past_competitions = @events.competitions.past
    @past_awards = @events.awards.past
  end

  def set_signed_in_user_vars
    @user = current_user
    @event_assignment = @user.event_assignment(@competition)
    @registration = Registration.find_by(
      event: @event,
      assignment: @event_assignment
    )
  end
end
