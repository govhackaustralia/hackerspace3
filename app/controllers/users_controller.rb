class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @competition = Competition.current

    @assignments = @user.assignments
    @assignment_titles = @assignments.pluck(:title)

    @team_id_assignments = {}
    @assignments.each do |assignment|
      next unless assignment.assignable_type == 'Team'
      @team_id_assignments[assignment.assignable_id] = assignment
    end

    @id_regions = Region.id_regions(Region.all)

    @event_assignment = @user.event_assignment
    @registrations = @event_assignment.registrations

    @sponsor_contact_assignments = @assignments.where(title: SPONSOR_CONTACT)
    @id_sponsors = Sponsor.id_sponsors(@sponsor_contact_assignments.pluck(:assignable_id))

    @favourite_teams = @event_assignment.teams

    team_ids = []
    team_ids << @favourite_teams.pluck(:id)

    @id_teams_projects = Team.id_teams_projects(team_ids.flatten)

    event_ids = []
    event_ids << @favourite_teams.pluck(:event_id)
    event_ids << @registrations.pluck(:event_id)

    @id_events = Event.id_events(event_ids.flatten)
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
      @user.update(user_params) unless params.nil?
      if @user.save
        account_update_successfully
      else
        render 'edit'
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :preferred_name, :preferred_img,
                                 :tshirt_size, :twitter, :phone_number,
                                 :mailing_list,
                                 :challenge_sponsor_contact_place,
                                 :challenge_sponsor_contact_enter,
                                 :my_project_sponsor_contact,
                                 :me_govhack_contact, :dietary_requirements,
                                 :organisation_name,
                                 :how_did_you_hear, :govhack_img,
                                 :accepted_terms_and_conditions)
  end

  def account_update_successfully
    if params[:user][:accepted_terms_and_conditions]
      flash[:notice] = 'Welcome! Please complete your registration.'
      redirect_to complete_registration_path
    elsif @account_registration
      handle_end_of_registration
    elsif params[:user][:govhack_img].present?
      flash[:notice] = 'GovHack Profile Uploaded'
      render :edit, profile_pic: true
    else
      flash[:notice] = 'Your personal details have been updated.'
      redirect_to manage_account_path
    end
  end

  def handle_end_of_registration
    if @user.how_did_you_hear.empty?
      current_user.update(how_did_you_hear: NO_RESPONSE)
    end
    flash[:notice] = 'Your account has been created.'
    redirect_to manage_account_path
  end
end
