class EventsController < ApplicationController
  def index
    retrieve_events
    respond_to do |format|
      format.html
      format.csv { send_data @events.to_csv }
    end
  end

  def show
    @event = Event.find_by identifier: params[:identifier]
    if @event.published || (user_signed_in? && current_user.event_privileges?)
      show_event
    else
      flash[:alert] = 'This event has not been published.'
      redirect_to root_path
    end
  end

  private

  def retrieve_events
    all = Competition.current.events.published.preload(:region).order start_time: :asc, name: :asc
    retrieve_all_future_events all
    retrive_all_past_events all
  end

  def retrieve_all_future_events(all)
    @future_connections = all.connections.future
    @future_locations = all.locations.future
    @future_remotes = all.remotes.future
    @future_awards = all.awards.future
  end

  def retrive_all_past_events(all)
    @past_connections = all.connections.past
    @past_competitions = all.competitions.past
    @past_awards = all.awards.past
  end

  def show_event
    @competition = @event.competition
    @event_partner = @event.event_partner
    @region = @event.region
    @sponsorship_types = @region.sponsorship_types.distinct.order order: :asc
    set_signed_in_user_vars if user_signed_in?
  end

  def set_signed_in_user_vars
    @user = current_user
    @registration = Registration.find_by event: @event,
                                         assignment: @user.event_assignment
    @team = @event.teams.new
  end
end
