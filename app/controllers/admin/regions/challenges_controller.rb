class Admin::Regions::ChallengesController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges
  before_action :check_for_competition_start!, only: :preview

  def index
    @challenges = @region.challenges
  end

  def show
    @challenge = Challenge.find params[:id]
    @challenge_sponsorships = @challenge.challenge_sponsorships
    @challenge_data_sets = @challenge.challenge_data_sets
    @judges = @challenge.judge_users
  end

  def preview
    @data_sets = @challenge.data_sets
    @sponsors = @challenge.sponsors.with_attached_logo
    @user_eligible_teams = []
    render 'challenges/show'
  end

  def new
    @challenge = @region.challenges.new
  end

  def create
    @challenge = @region.challenges.new challenge_params
    if @challenge.save
      flash[:notice] = 'New Challenge Created'
      redirect_to admin_region_challenge_path @region, @challenge
    else
      flash[:alert] = @challenge.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @challenge = Challenge.find params[:id]
  end

  def update
    @challenge = Challenge.find params[:id]
    @challenge.update(challenge_params) unless params[:challenge].blank?
    handle_update
  end

  private

  def check_for_competition_start!
    @challenge = Challenge.find params[:id]
    return unless @competition.started? @region.time_zone

    flash[:alert] = 'Competition has started, no need for challenge preview'
    redirect_to challenge_path @challenge.identifier
  end

  # ENHANCEMENT: Break into seperate methods or controllers.
  def handle_update_redirect
    if params[:image].present?
      updated_image
    elsif params[:pdf].present?
      updated_pdf
    elsif params[:pdf_preview].present?
      updated_pdf_preview
    else
      updated_challenge
    end
  end

  def updated_image
    flash[:notice] = 'Challenge Image Updated'
    render :edit, image: true
  end

  def updated_pdf
    flash[:notice] = 'Challenge PDF Updated'
    render :edit, pdf: true
  end

  def updated_pdf_preview
    flash[:notice] = 'Challenge PDF Preview Updated'
    render :edit, pdf_preview: true
  end

  def updated_challenge
    flash[:notice] = 'Challenge Updated'
    redirect_to admin_region_challenge_path @region, @challenge
  end

  def handle_update
    if @challenge.save
      handle_update_redirect
    else
      flash[:alert] = @challenge.errors.full_messages.to_sentence
      render :edit
    end
  end

  def check_for_privileges
    @region = @competition.regions.find_by_identifier params[:region_id]
    @competition = @region.competition
    return if current_user.region_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def challenge_params
    params.require(:challenge).permit(
      :name, :short_desc, :long_desc, :eligibility, :video_url, :approved,
      :image, :pdf, :pdf_preview, :nation_wide
    )
  end
end
