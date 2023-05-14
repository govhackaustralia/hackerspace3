# frozen_string_literal: true

class Admin::RegistrationsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  # ENHANCEMENT: Rearrange columns in table.
  def index
    @region = @event.region
    @registrations = @event.registrations.preload assignment: :user
    respond_to do |format|
      format.html
      format.csv { send_data @event.registrations_to_csv }
    end
  end

  def new
    @region = @event.region
    @registration = @event.registrations.new
    search_for_users unless params[:term].blank?
  end

  def create
    @registration = @event.registrations.new registration_params
    @registration.time_notified = Time.now.in_time_zone LAST_COMPETITION_TIME_ZONE
    if @registration.save
      flash[:notice] = 'New Registration Added.'
      redirect_to admin_event_registrations_path @event
    else
      create_error
    end
  end

  # ENHANCEMENT: Amend view to account for other registration types in nation
  # awards.
  def edit
    @region = @event.region
    @registration = Registration.find params[:id]
    @event_assignment = @registration.assignment
    @user = @event_assignment.user
  end

  def update
    @registration = Registration.find params[:id]
    if @registration.update registration_params
      flash[:notice] = 'Registration Updated.'
      redirect_to admin_event_registrations_path @event
    else
      update_error
    end
  end

  private

  def registration_params
    params.require(:registration).permit :status, :assignment_id, :holder_id
  end

  def search_for_users
    @user = User.find_by_email params[:term]
    if @user.present?
      @existing_registration = @user.registrations.find_by event: @event
      @event_assignment = @user.event_assignment @competition
    else
      @users = User.search(params[:term]).preload :assignments
    end
  end

  def create_error
    flash.now[:alert] = @registration.errors.full_messages.to_sentence
    @assignment = @registration.assignment
    @user = @assignment.user
    @event_assignment = @user.event_assignment @event.competition
    render :new
  end

  def update_error
    flash.now[:alert] = @registration.errors.full_messages.to_sentence
    @user = @registration.user
    @region = @event.region
    @event_assignment = @user.event_assignment @region.competition
    render :edit
  end

  def check_for_privileges
    @event = Event.find params[:event_id]
    @competition = @event.competition
    return if current_user.event_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
