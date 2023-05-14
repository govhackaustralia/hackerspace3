# frozen_string_literal: true

class Admin::ProfilesController < ApplicationController
  before_action :authenticate_user!, :authorise_user!

  def update
    @profile = Profile.find_by_identifier params[:id]
    if @profile.update(profile_params)
      flash[:notice] = 'Profile updated'
    else
      flash[:alert] = @profile.errors.full_messages.to_sentence
    end
    redirect_to admin_user_path(@profile.user_id)
  end

  private

  def profile_params
    params.require(:profile).permit(:published)
  end

  def authorise_user!
    return if current_user.admin_privileges? Competition.all

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
