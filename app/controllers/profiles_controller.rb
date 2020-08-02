class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :authorize_user!, only: %i[edit update]

  def index
    @profiles = Profile.all.where.not(identifier: nil).preload(:user).includes(:skills)
  end

  def show
    @profile = Profile.find_by_identifier params[:id]
    @user = @profile.user
    @badges = @user.badges
    @team_name = @user.joined_teams.first&.current_project&.team_name
  end

  def edit; end

  def update
    @profile.update profile_params
    redirect_to profile_path(@profile), notice: 'Your Profile has been updated'
  end

  private

  def profile_params
    params.require(:profile).permit(:team_status, :description, :website,
      :twitter, :linkedin, :skill_list, :interest_list)
  end

  def authorize_user!
    @profile = Profile.find_by_identifier params[:id]
    return if current_user.profile == @profile

    redirect_to profile_path(@profile),
      alert: 'You are not permitted to edit this Profile'
  end
end
