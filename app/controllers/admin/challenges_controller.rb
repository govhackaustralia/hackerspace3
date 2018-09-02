class Admin::ChallengesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def show
    @region = Region.find(params[:region_id])
    @challenge = Challenge.find(params[:id])
    @challenge_sponsorships = @challenge.challenge_sponsorships
  end

  def new
    @region = Region.find(params[:region_id])
    @challenge = @region.challenges.new
  end

  def edit
    @region = Region.find(params[:region_id])
    @challenge = Challenge.find(params[:id])
  end

  def create
    create_new_challenge
    if @challenge.save
      flash[:notice] = 'New Challenge Created'
      redirect_to admin_region_challenge_path(@region, @challenge)
    else
      flash[:alert] = @challenge.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    update_challenge
    @challenge.update(challenge_params) unless params[:challenge].blank?
    if @challenge.save
      handle_update_redirect
    else
      flash[:alert] = @challenge.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def handle_update_redirect
    if params[:image].present?
      flash[:notice] = 'Challenge Image Updated'
      render :edit, image: true
    elsif params[:pdf].present?
      flash[:notice] = 'Challenge PDF Updated'
      render :edit, pdf: true
    elsif params[:pdf_preview].present?
      flash[:notice] = 'Challenge PDF Preview Updated'
      render :edit, pdf_preview: true
    else
      flash[:notice] = 'Challenge Updated'
      redirect_to admin_region_challenge_path(@region, @challenge)
    end
  end

  def check_for_privileges
    return if current_user.region_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def challenge_params
    params.require(:challenge).permit(:name, :short_desc, :long_desc,
                                      :eligibility, :video_url, :data_set_url,
                                      :approved, :image, :pdf, :pdf_preview)
  end

  def update_challenge
    @region = Region.find(params[:region_id])
    @challenge = Challenge.find(params[:id])
  end

  def create_new_challenge
    @region = Region.find(params[:region_id])
    @challenge = @region.challenges.new(challenge_params)
    @challenge.competition = Competition.current
  end
end
