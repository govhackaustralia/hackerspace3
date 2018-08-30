class EventsController < ApplicationController
  def index
    retrieve_events
    @id_regions = Region.id_regions(@events.pluck(:region_id))
    respond_to do |format|
      format.html
      format.csv { send_data @events.to_csv }
    end
  end

  def show
    @event = Event.find_by(identifier: params[:identifier])
    @event_partner = @event.event_partner
    @region = @event.region
    @sponsorship_types = @region.sponsorship_types.distinct.order(order: :asc)
    set_signed_in_user_vars if user_signed_in?
  end

  private

  def retrieve_events
    @events = if params[:event_type].present?
                Competition.current.events.where(event_type: params[:event_type]).order(start_time: :asc, name: :asc)
              else
                Competition.current.events.order(start_time: :asc, name: :asc)
              end
  end

  def set_signed_in_user_vars
    @user = current_user
    @registration = Registration.find_by(event: @event, assignment: @user.event_assignment)
    @team = @event.teams.new
  end
end
