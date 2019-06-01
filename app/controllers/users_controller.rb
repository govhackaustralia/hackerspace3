class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @competition = Competition.current

    @assignments = @user.assignments.where competition: @competition
    @assignment_titles = @assignments.pluck :title

    @event_assignment = @user.event_assignment @competition
    @registrations = @event_assignment.registrations.preload event: :region

    @sponsor_contact_assignments = @assignments.sponsor_contacts.preload :assignable

    @favourite_teams = @event_assignment.favourite_teams.published.preload :event, :current_project

    @joined_teams = @user.joined_teams.competition(@competition).preload :event, :current_project, :region
    @invited_team_assignments = @user.invited_team_assignments.where(competition: @competiton).preload assignable: [:event, :current_project]

    @public_winning_entries = has_public_winning_entries?
    @region_privileges = @user.region_privileges?(@competition)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @account_registration = @user.registering_account?
    if params[:user].nil?
      redirect_to root_path
    else
      handle_update_user
    end
  end

  private

  def user_params
    params.require(:user).permit :full_name, :preferred_name, :preferred_img,
                                 :tshirt_size, :twitter, :phone_number,
                                 :mailing_list,
                                 :challenge_sponsor_contact_place,
                                 :challenge_sponsor_contact_enter,
                                 :my_project_sponsor_contact,
                                 :me_govhack_contact, :dietary_requirements,
                                 :organisation_name, :how_did_you_hear,
                                 :govhack_img, :accepted_terms_and_conditions,
                                 :bsb, :acc_number, :acc_name, :branch_name
  end

  def handle_update_user
    @user.update user_params unless params.nil?
    if @user.save
      account_update_successfully
    else
      render 'edit'
    end
  end

  def account_update_successfully
    if params[:user][:accepted_terms_and_conditions]
      handle_complete_registration
    elsif @account_registration
      handle_end_of_registration
    elsif params[:user][:govhack_img].present?
      handle_profile_img
    elsif params[:banking].present?
      handle_bank_update
    else
      handle_personal_details
    end
  end

  def handle_complete_registration
    flash[:notice] = 'Welcome! Please complete your registration.'
    redirect_to complete_registration_path
  end

  def handle_end_of_registration
    current_user.update(how_did_you_hear: NO_RESPONSE) if @user.how_did_you_hear.empty?
    flash[:notice] = 'Your account has been created.'
    redirect_to manage_account_path
  end

  def handle_profile_img
    flash[:notice] = 'GovHack Profile Uploaded'
    render :edit, profile_pic: true
  end

  def handle_bank_update
    BankMailer.notify_finance(@user).deliver_later
    flash[:notice] = 'Your banking details have been updated.'
    redirect_to manage_account_path
  end

  def handle_personal_details
    flash[:notice] = 'Your personal details have been updated.'
    redirect_to manage_account_path
  end

  def has_public_winning_entries?
    @user.winning_entries.preload(challenge: :region).each do |entry|
      return true if entry.challenge.region.awards_released?
    end
    false
  end
end
