class Admin::Events::IndividualGoldensController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def new
    search_for_users unless params[:term].blank?
  end

  def create
    create_new
    if @registration.save
      flash[:notice] = 'New Registration Added.'
      redirect_to admin_event_registrations_path @event
    else
      flash.now[:alert] = @registration.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def check_for_privileges
    @event = Event.find params[:event_id]
    return if current_user.event_privileges? @event.competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def search_for_users
    @user = User.find_by_email params[:term]
    if @user.present?
      @existing_registration = @user.registrations.find_by event: @event
    else
      @users = User.search params[:term]
    end
  end

  def create_new
    @registration = @event.registrations.invited.new
    user = User.find_by id: params[:user_id]
    return if user.nil?

    assignment = Assignment.find_or_create_by user: user, title: GOLDEN_TICKET,
                                              assignable: @event.competition
    @registration.assignment = assignment
    @registration.time_notified = Time.now.in_time_zone COMP_TIME_ZONE
  end
end
