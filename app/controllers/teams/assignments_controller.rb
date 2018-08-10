class Teams::AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def new
    new_assignment
    return if params[:term].blank?
    @user = User.find_by_email(params[:term])
    search_for_existing_registration if @user.present?
    search_other_fields unless @user.present?
  end

  def create
    create_new_assignment
    if @assignment.save
      flash[:notice] = "New #{params[:title]} Assignment Added."
      redirect_to team_path(@assignable)
    else
      flash.now[:alert] = @assignment.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def new_assignment
    @assignable = Team.find(params[:team_id])
    @assignment = @assignable.assignments.new
    @title = params[:title]
  end

  def create_new_assignment
    @assignable = Team.find(params[:team_id])
    @user = User.find(params[:user_id]) unless params[:user_id].blank?
    @user ||= new_user_for_valid_email
    @assignment = @assignable.assignments.new(user: @user, title: params[:title])
  end

  def search_other_fields
    @users = User.search(params[:term])
  end

  def new_user_for_valid_email
    @user = User.new(email: params[:email])
    @user.password = Devise.friendly_token[0, 20]
    @user.skip_confirmation_notification!
    @user.save
    @user
  end

  def search_for_existing_registration
    @existing_registration = @user.assignments.find_by(assignable: @assignable, title: TEAM_ADMIN)
  end
end
