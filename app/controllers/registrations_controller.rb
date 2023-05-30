# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find_by(identifier: params[:event_identifier])
    @region = @event.region
    @registration = @event.registrations.new
    @user = current_user
    @event_assignment = @user.event_assignment(@competition)
    check_for_existing_competition_event
  end

  def show
    @user = current_user
    @registration = Registration.find(params[:id])
    @assignment = @registration.assignment
    @event = @registration.event
    @region = @event.region
  end

  def edit
    @registration = Registration.find(params[:id])
    @event = @registration.event
    @region = @event.region
    @user = current_user
    @assignment = @registration.assignment
  end

  def update
    check_code_of_conduct
    update_registration
    update_user_preferences
    handle_update
  end

  # Hard to check Create Method when it is so long.
  # ENHANCEMENT: Break up method across controllers.
  def create
    check_code_of_conduct
    create_new_registration
    update_user_preferences
    handle_create
  end

  def limit_reached
    @event = Event.find_by identifier: params[:event_identifier]
    @competition = @event.competition
    @registration = current_user.event_assignment(@competition).competition_event_registration
    if @registration.present?
      @current_event = @registration.event
    else
      flash[:alert] = "Your limit has not been reached for #{@competition.year}"
      redirect_to event_path(@event.identifier)
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:status)
  end

  def check_for_existing_competition_event
    return if helpers.participant_able_to_enter?

    flash[:alert] = 'Already registered for a Competition Event'
    redirect_to event_path(@event.identifier)
  end

  def handle_create
    if parent_guardian_missing_and_needed?
      flash[:alert] = 'Parent/Guardian name must be filled in for Youth Competitor'
      render :new
    elsif @registration.save
      handle_new_save
    else
      flash[:alert] = @registration.errors.full_messages.to_sentence
      render :new
    end
  end

  def handle_update
    if parent_guardian_missing_and_needed?
      flash[:alert] = 'Parent/Guardian name must be filled in for Youth Competitor'
      render :edit
    elsif @registration.save
      flash[:notice] = 'Your registration has been updated'
      redirect_to event_registration_path(@event.identifier, @registration)
    else
      flash[:alert] = @registration.errors.full_messages.to_sentence
      render :edit
    end
  end

  def parent_guardian_missing_and_needed?
    @user.registration_type == YOUTH_COMPETITOR && @user.parent_guardian.blank?
  end

  def handle_new_save
    flash[:notice] = if params[:status] == ATTENDING
      'You have registered for this event.'
    else
      'You have been added to the waitlist.'
    end

    redirect_to event_registration_path(@event.identifier, @registration)
  end

  def create_new_registration
    @event = Event.find(params[:event_identifier])
    @region = @event.region
    @registration = @event.registrations.new(status: params[:status])
    @user = current_user
    @registration.assignment = @user.event_assignment @event.competition
    @registration.holder = @holder
    @registration.time_notified = Time.now.in_time_zone(LAST_COMPETITION_TIME_ZONE)
  end

  def update_registration
    @registration = Registration.find(params[:id])
    @event = @registration.event
    @region = @event.region
    @registration.update(registration_params)
    @registration.update(time_notified: Time.now.in_time_zone(LAST_COMPETITION_TIME_ZONE))
    @user = current_user
  end

  def check_code_of_conduct
    return unless params[:accepted_code_of_conduct] == 'true'

    current_user.update accepted_code_of_conduct: Time.now.in_time_zone(LAST_COMPETITION_TIME_ZONE)
  end

  def update_user_preferences
    update_standard_event_attrs
    return unless @event.event_type == COMPETITION_EVENT

    update_competition_event_attrs
    update_skills_attrs
  end

  def update_standard_event_attrs
    @user.update(
      preferred_name: params[:preferred_name],
      organisation_name: params[:organisation_name],
      dietary_requirements: params[:dietary_requirements],
      registration_type: params[:registration_type],
      parent_guardian: params[:parent_guardian],
    )
  end

  def update_competition_event_attrs
    @user.update(
      request_not_photographed: params[:request_not_photographed],
    )
  end

  def update_skills_attrs
    @user.update(
      data_cruncher: params[:data_cruncher],
      coder: params[:coder],
      creative: params[:creative],
      facilitator: params[:facilitator],
    )
  end
end
