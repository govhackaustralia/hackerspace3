class Admin::RegionsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @region = @competition.root_region
  end

  def show
    @region = Region.find params[:id]
    @parent = @region.parent
    @director = @region.director
    @supports_count = @region.supports.count
    retrieve_events_and_counts
    retrieve_children_counts
    retrieve_counts
  end

  def new
    @region = Region.new
  end

  def create
    create_new_region
    if @region.save
      flash[:notice] = "New Region '#{@region.name}' added."
      redirect_to admin_competition_region_path @competition, @region
    else
      flash.now[:alert] = @region.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @region = Region.find params[:id]
  end

  def update
    retrieve_region_and_comp
    if @region.update region_params
      flash[:notice] = 'Region Updated'
      redirect_to admin_competition_region_path @competition, @region
    else
      flash.now[:alert] = @region.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def region_params
    params.require(:region).permit :time_zone, :name, :award_release
  end

  def check_for_privileges
    @competition = Competition.find params[:competition_id]
    return if current_user.region_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def retrieve_region_and_comp
    @region = Region.find params[:id]
    @competition = @region.competition
  end

  def create_new_region
    @competition = Competition.find params[:competition_id]
    @region = @competition.regions.new region_params
    @region.parent = @competition.root_region
  end

  def retrieve_counts
    if @region.national?
      retrieve_national_counts
    else
      @event_counts = helpers.challenges_event_counts @region
      @event_names = @region.events.competitions.order(:name).pluck :name
      @challenge_names = @region.challenges.order(:name).pluck :name
    end
  end

  def retrieve_events_and_counts
    @events = @region.events
    @connections_count = @events.connections.count
    @competitions_count = @events.competitions.count
    @awards_count = @events.awards.count
  end

  def retrieve_children_counts
    @sponsorships_count = @region.sponsorships.count
    @data_sets_count = @region.data_sets.count
    @challenges_count = @region.challenges.count
    @bulk_mails_count = @region.bulk_mails.count
  end

  def retrieve_national_counts
    @region_counts = helpers.challenges_region_counts
    @region_names = Region.where.not(parent_id: nil).order(:name).pluck(:name)
    @challenge_names = @competition.root_region.challenges.order(:name).pluck(:name)
  end
end
