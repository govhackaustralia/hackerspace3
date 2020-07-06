class ProfilesController < ApplicationController
  def index
    @profiles = Profile.all.where.not(identifier: nil).preload(:user).includes(:skills)
  end

  def show
    @profile = Profile.find_by_identifier params[:id]
    @user = @profile.user
  end
end
