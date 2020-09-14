class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update slack_chat]
  before_action :authorize_user!, only: %i[edit update]
  before_action :check_profile_found!, :check_published!, only: :show

  def index
    @profiles = @competition.profiles.published
      .where.not(identifier: [nil, ''])
      .preload(:user)
      .includes(:skills)
  end

  def participants
    # user_registration_scoped_profiles(PARTICIPANT_TYPES)
    redirect_to profiles_path
  end

  def mentors
    # user_registration_scoped_profiles(MENTOR_TYPES)
    redirect_to profiles_path
  end

  def industry
    # user_registration_scoped_profiles(INDUSTRY_TYPES)
    redirect_to profiles_path
  end

  def support
    # user_registration_scoped_profiles(SUPPORT_TYPES)
    redirect_to profiles_path
  end

  def show
    @user = @profile.user
    @badge_assignments = @user.badge_assignments
    @joined_projects = @user.joined_projects.joins(:competition).where(competitions: {id: @competition.id})
  end

  def edit; end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path(@profile), notice: 'Your Profile has been updated'
    else
      flash[:alert] = @profile.errors.full_messages.to_sentence
      render :edit
    end
  end

  def slack_chat
    @other_profile = Profile.find_by_identifier params[:id]
    response = Excon.post('https://slack.com/api/conversations.open',
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      body: URI.encode_www_form(token: profile.slack_access_token, users: @other_profile.slack_user_id))
    channel_id = JSON.parse(response.body).dig('channel', 'id')
    if channel_id.present?
      redirect_to "https://app.slack.com/client/#{ENV['SLACK_TEAM_ID']}/#{channel_id}"
    else
      redirect_to profile_path(@other_profile), alert: 'Something went wrong'
    end
  end

  private

  def user_registration_scoped_profiles(registration_types)
    @profiles = Profile.published
      .where(user: User.where(registration_type: registration_types))
      .where.not(identifier: nil)
      .where.not(identifier: '')
      .preload(:user)
      .includes(:skills)
  end

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
end
