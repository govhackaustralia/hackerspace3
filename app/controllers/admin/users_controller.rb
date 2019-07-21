class Admin::UsersController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @users = if params[:term].blank?
               User.take 10
             else
               User.search params[:term]
             end
    respond_to do |format|
      format.html
      format.csv { send_data User.user_event_rego_to_csv @competition }
    end
  end

  def show
    @user = User.find params[:id]
    @event_assignments = @user.event_assignments.order(competition_id: :desc).preload :competition
  end

  def new
    @user = User.new
  end

  def create
    create_new_unauthed_user
    if @user.save
      flash[:notice] = 'New user saved'
      redirect_to admin_user_path @user
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  def confirm
    @user = User.find params[:id]
    @user.confirm
    redirect_to admin_user_path @user
  end

  def unconfirmed
    @users = User.all.where confirmed_at: nil
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges? Competition.all

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :full_name, :email
  end

  # ENHANCEMENT: Redo when user auth seperated.
  def create_new_unauthed_user
    @user = User.new user_params
    @user.password = Devise.friendly_token[0, 20]
    @user.skip_confirmation_notification!
  end
end
