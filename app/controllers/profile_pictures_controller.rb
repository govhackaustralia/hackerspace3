class ProfilePicturesController < ApplicationController
  before_action :authenticate_user!, :profile

  def edit; end

  def update
    if @profile.update profile_params
      flash[:notice] = 'Profile Picture updated'
    else
      flash[:alert] = @profile.errors.full_messages.to_sentence
    end
    render :edit
  end

  private

  def profile_params
    params.require(:profile).permit(:profile_picture)
  end
end
