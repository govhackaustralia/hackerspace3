class EventsController < ApplicationController
  def index
    @events = retrieve_events
    @id_regions = Region.id_regions(@events.pluck(:region_id))
    respond_to do |format|
      format.html
      format.csv { send_data @events.to_csv }
    end
  end

  def show
    @event = Event.find_by(identifier: params[:identifier])
    if @event.published || (user_signed_in? && current_user.event_privileges?)
      @competition = @event.competition
      @event_partner = @event.event_partner
      @region = @event.region
      @sponsorship_types = @region.sponsorship_types.distinct.order(order: :asc)
      set_signed_in_user_vars if user_signed_in?
    else
      flash[:alert] = 'This event has not been published.'
      redirect_to root_path
    end
  end

  private

  def retrieve_events
    if params[:event_type].present?
      Competition.current.events.where(event_type: params[:event_type], published: true).order(start_time: :asc, name: :asc)
    else
      Competition.current.events.where(published: true).order(start_time: :asc, name: :asc)
    end
  end

  def set_signed_in_user_vars
    @user = current_user
    @registration = Registration.find_by(event: @event, assignment: @user.event_assignment)
    @team = @event.teams.new
  end
end
