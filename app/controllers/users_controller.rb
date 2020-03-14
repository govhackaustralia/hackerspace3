class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    @assignments = @user.assignments.where competition: @competition
    @assignment_titles = @assignments.pluck :title

    @event_assignment = @user.event_assignment @competition

    @connection_registrations = @event_assignment.registrations.connection_events.preload event: :region
    @competition_registrations = @event_assignment.registrations.competition_events.preload event: :region
    @award_registrations = @event_assignment.registrations.award_events.preload event: :region

    @sponsor_contact_assignments = @assignments.sponsor_contacts.preload :assignable

    @judging_assignments = @assignments.judges

    @favourite_teams = @event_assignment.favourite_teams.published.preload :event, :current_project

    @joined_teams = @user.joined_teams.competition(@competition).preload :event, :current_project, :region
    @invited_team_assignments = @user.invited_team_assignments.where(competition: @competition)

    @public_winning_entries = has_public_winning_entries? @competition
    @region_privileges = @user.region_privileges? @competition

    @participating_competition_event = @user.participating_competition_event @competition
    @time_zone = @participating_competition_event&.region&.time_zone
  end

  def edit
    @user = current_user
  end

  def review_terms_and_conditions
    @user = current_user
  end

  def accept_terms_and_conditions
    @user = current_user
    @user.update accept_terms_params
    if @user.save && @user.accepted_terms_and_conditions
      flash[:notice] = 'Welcome! Please complete your registration.'
      redirect_to complete_registration_path
    else
      flash[:alert] = 'Please accept our terms and conditions before continuing'
      redirect_to review_terms_and_conditions_path
    end
  end

  def complete_registration_edit
    @user = current_user
  end

  def complete_registration_update
    @user = current_user
    @user.update complete_registration_params
    if @user.save && @user.full_name.present?
      flash[:notice] = 'Your account has been created.'
      redirect_to session[:user_return_to] || manage_account_path
    else
      flash[:alert] = 'Plese enter your Full name before proceeding'
      redirect_to complete_registration_path
    end
  end

  def update
    @user = current_user
    if params[:user].nil?
      redirect_to root_path
    else
      handle_update_user
    end
  end

  private

  def accept_terms_params
    params.require(:user).permit :accepted_terms_and_conditions
  end

  def complete_registration_params
    params.require(:user).permit(:how_did_you_hear, *user_permitted_attributes)
  end

  def user_params
    params.require(:user).permit(
      :tshirt_size,
      :govhack_contact,
      :dietary_requirements,
      :govhack_img,
      :bsb,
      :acc_number,
      :acc_name,
      :branch_name,
      *user_permitted_attributes
    )
  end

  def user_permitted_attributes
    %i[
      full_name
      preferred_name
      organisation_name
      phone_number
      twitter
      slack
      mailing_list
      challenge_sponsor_contact_place
      challenge_sponsor_contact_enter
      my_project_sponsor_contact
      me_govhack_contact
    ]
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
    if params[:user][:govhack_img].present?
      handle_profile_img
    elsif params[:banking].present?
      handle_bank_update
    else
      handle_personal_details
    end
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

  def has_public_winning_entries?(competition)
    @user.winning_entries.competition(competition).preload(challenge: :region).each do |entry|
      return true if entry.challenge.region.awards_released?
    end
    false
  end
end
