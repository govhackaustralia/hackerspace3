# frozen_string_literal: true

class Admin::RegionsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges
  before_action :retrieve_parent_regions, except: %i[index show]

  def index
    @regions = @competition.regions
  end

  def show
    @region = @competition.regions.find_by_identifier params[:id]
    @parent = @region.parent
    @director = @region.director
    @supports_count = @region.supports.count
    retrieve_events_and_counts
    retrieve_children_counts
    retrieve_counts
  end

  def new
    @region = @competition.regions.new
  end

  def create
    @region = @competition.regions.new region_params
    if @region.save
      flash[:notice] = "New Region '#{@region.name}' added."
      redirect_to admin_competition_region_path @competition, @region
    else
      flash.now[:alert] = @region.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @region = @competition.regions.find_by_identifier params[:id]
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
    params.require(:region).permit(
      :time_zone,
      :name,
      :award_release,
      :category,
      :parent_id
    )
  end

  def check_for_privileges
    @competition = Competition.find params[:competition_id]
    return if current_user.region_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def retrieve_region_and_comp
    @region = @competition.regions.find_by_identifier params[:id]
    @competition = @region.competition
  end

  def retrieve_parent_regions
    @parent_regions = @competition.regions.highs
  end

  def retrieve_counts
    if @region.international?
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
  end

  def retrieve_national_counts
    @region_counts = helpers.challenges_region_counts @competition
    @region_names = @competition.regions.lows.order(:name).pluck(:name)
    @challenge_names = @competition.international_region.challenges.order(:name).pluck(:name)
  end
end
