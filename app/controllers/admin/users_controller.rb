class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @event_assignment = @user.event_assignment
  end

  def create
    @user = User.new(user_params)
    @user.password = Devise.friendly_token[0, 20]
    @user.skip_confirmation_notification!
    @user.save
    if @user.persisted?
      flash[:notice] = 'New user saved'
      redirect_to admin_user_path(@user)
    else
      flash[:notice] = @user.errors.full_messages.to_sentence
      render new_admin_user_path(@user)
    end
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:full_name, :email)
  end
end
