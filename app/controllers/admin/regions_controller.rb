class Admin::RegionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @region = Region.root
  end

  def new
    @region = Region.new if @region.nil?
  end

  def edit
    @region = Region.find(params[:id])
  end

  def create
    create_new_region
    if @region.save
      flash[:notice] = "New Region '#{@region.name}' added."
      redirect_to admin_regions_path
    else
      flash.now[:alert] = @region.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @region = Region.find(params[:id])
    if @region.update(region_params)
      flash[:notice] = 'Region Updated'
      redirect_to admin_region_path(@region)
    else
      flash.now[:alert] = @region.errors.full_messages.to_sentence
      render :edit
    end
  end

  def show
    @region = Region.find(params[:id])
    @competition = Competition.current
    if @region.national?
      @region_counts = Region.national_challenges_region_counts
      @region_names = Region.where.not(parent_id: nil).order(:name).pluck(:name)
      @challenge_names = Region.root.challenges.order(:name).pluck(:name)
    else
      @event_counts = @region.regional_challenges_event_counts
      @event_names = @competition.events.where(event_type: COMPETITION_EVENT, region: @region).order(:name).pluck(:name)
      @challenge_names = @region.challenges.order(:name).pluck(:name)
    end
  end

  private

  def region_params
    params.require(:region).permit(:time_zone, :name)
  end

  def check_for_privileges
    return if current_user.region_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def create_new_region
    @region = Region.new(region_params)
    @region.update(parent_id: Region.root.id)
  end
end
