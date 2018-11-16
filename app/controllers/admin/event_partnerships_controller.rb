class Admin::EventPartnershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def new
    new_event_partnership
    return if params[:term].blank?

    @sponsor = Sponsor.find_by_name(params[:term])
    @sponsors = Sponsor.search(params[:term]) unless @sponsor.present?
  end

  def create
    create_new_event_partnership
    if @event_partnership.save
      flash[:notice] = 'New Event Partner Added.'
      redirect_to admin_region_event_path(@event.region, @event)
    else
      flash.now[:alert] = @assignment.errors.full_messages.to_sentence
      render :new
    end
  end

  def destroy
    @event_partnership = EventPartnership.find(params[:id])
    @sponsor = @event_partnership.sponsor
    @event_partnership.destroy
    flash[:notice] = 'Event Partnership Destroyed'
    redirect_to admin_sponsor_path(@sponsor)
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def new_event_partnership
    @event = Event.find(params[:event_id])
    @event_partnership = EventPartnership.new
  end

  def create_new_event_partnership
    @event = Event.find(params[:event_id])
    @sponsor = Sponsor.find(params[:sponsor_id])
    @event_partnership = EventPartnership.new(event: @event, sponsor: @sponsor)
  end
end
