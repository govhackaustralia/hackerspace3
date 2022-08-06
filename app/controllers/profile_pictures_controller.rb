class ProfilePicturesController < ApplicationController
  include ContentPolicy

  before_action :authenticate_user!, :profile
  before_action :check_content_policy!, only: :update

  def edit; end

  def update
    if @profile.update profile_params
      redirect_to update_profile_picture_path,
        notice: 'Profile Picture updated'
    else
      flash[:alert] = @profile.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def edit_template
    :edit
  end

  def profile_params
    params.require(:profile).permit(:profile_picture)
  end
end
