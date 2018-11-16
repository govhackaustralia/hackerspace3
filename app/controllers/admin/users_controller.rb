class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @users = if params[:term].blank?
               User.take(10)
             else
               User.search(params[:term])
             end
     respond_to do |format|
       format.html
       format.csv { send_data User.user_event_rego_to_csv }
     end
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @event_assignment = @user.event_assignment
  end

  def create
    create_new_unauthed_user
    if @user.save
      flash[:notice] = 'New user saved'
      redirect_to admin_user_path(@user)
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render new_admin_user_path(@user)
    end
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:full_name, :email)
  end

  def create_new_unauthed_user
    @user = User.new(user_params)
    @user.password = Devise.friendly_token[0, 20]
    @user.skip_confirmation_notification!
  end
end
