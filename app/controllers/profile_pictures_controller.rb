class ProfilePicturesController < ApplicationController
  before_action :authenticate_user!, :profile

  def edit; end

  def update
    if @profile.update profile_params
      redirect_to manage_account_path,
        notice: 'Profile Picture updated'
    else
      flash[:alert] = @profile.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:profile_picture)
  end
end
