class Admin::ChallengesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def show
    @region = Region.find(params[:region_id])
    @challenge = Challenge.find(params[:id])
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
    @region = Region.find(params[:region_id])
    @challenge = @region.challenges.new(challenge_params)
    @challenge.update(competition: Competition.current)
    if @challenge.save
      flash[:notice] = 'New Challenge Created'
      redirect_to admin_region_challenge_path(@region, @challenge)
    else
      @challenge.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @region = Region.find(params[:region_id])
    @challenge = Challenge.find(params[:id])
    if @challenge.update(challenge_params)
      flash[:notice] = 'Challenge Updated'
      redirect_to admin_region_challenge_path(@region, @challenge)
    else
      @challenge.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def challenge_params
    params.require(:challenge).permit(:name, :short_desc, :long_desc,
                   :eligibility, :video_url, :data_set_url)
  end
end
