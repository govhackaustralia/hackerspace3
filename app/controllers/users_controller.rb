class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if current_user.update(user_params)
      redirect_to manage_account_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name)
  end
end
