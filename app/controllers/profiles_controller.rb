# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :authorize_user!, only: %i[edit update]
  before_action :check_profile_found!, :check_published!, only: :show

  def index
    @profiles = @competition.profiles.published
      .where.not(identifier: [nil, ''])
      .preload(:user)
      .includes(:skills)
  end

  def show
    @user = @profile.user
    @badge_assignments = @user.badge_assignments
    @joined_published_projects = @user.joined_published_projects
      .joins(:competition)
      .where(competitions: {id: @competition.id})
  end

  def edit
    @user = current_user
  end

  def update
    check_code_of_conduct
    if @profile.update(profile_params)
      redirect_to profile_path(@profile), notice: 'Your Profile has been updated'
    else
      @user = current_user
      flash[:alert] = @profile.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:team_status, :description, :website,
      :github, :twitter, :linkedin, :skill_list, :interest_list, :published).merge(published: true)
  end

  def authorize_user!
    @profile = Profile.find_by_identifier params[:id]
    return if current_user.profile == @profile

    redirect_to profile_path(@profile),
      alert: 'You are not permitted to edit this Profile'
  end

  def check_profile_found!
    @profile = Profile.find_by_identifier params[:id]

    return if @profile.present?

    redirect_to profiles_path, alert: "Could not find Profile: '#{params[:id]}'"
  end

  def check_published!
    return if @profile.published

    if user_signed_in? && current_user.profile == @profile
      flash[:alert] = 'This Profile is not yet published, only you can see it.'
      return
    end

    redirect_to profiles_path, alert: 'This Profile has not been published yet'
  end

  def check_code_of_conduct
    return unless params[:accepted_code_of_conduct] == 'true'

    current_user.update accepted_code_of_conduct: Time.now.in_time_zone(LAST_COMPETITION_TIME_ZONE)
  end
end
