class Admin::EventPartnersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def new
    new_event_partner
    return if params[:term].nil? || params[:term] == ''
    @sponsor = Sponsor.find_by_name(params[:term])
    @sponsors = Sponsor.search(params[:term]) unless @sponsor.present?
  end

  def create
    create_new_event_partner
    if @event_partner.save
      flash[:notice] = 'New Event Partner Added.'
      redirect_to admin_region_event_path(@event.region, @event)
    else
      flash.now[:notice] = @assignment.errors.full_messages.to_sentence
      render 'new'
    end
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def new_event_partner
    @event = Event.find(params[:event_id])
    @event_partner = EventPartner.new
  end

  def create_new_event_partner
    @event = Event.find(params[:event_id])
    @sponsor = Sponsor.find(params[:sponsor_id])
    @event_partner = EventPartner.new(event: @event, sponsor: @sponsor)
  end
end
