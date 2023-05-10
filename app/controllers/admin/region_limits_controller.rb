# frozen_string_literal: true

class Admin::RegionLimitsController < ApplicationController
  before_action :authenticate_user!, :authorise_user!, :retrieve_regions

  def new
    @region_limit = @checkpoint.region_limits.new
  end

  def create
    @region_limit = @checkpoint.region_limits.new region_limit_params
    if @region_limit.save
      flash[:notice] = 'New  Region Limit created'
      redirect_to admin_competition_checkpoints_path @competition
    else
      flash[:alert] = @region_limit.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @region_limit = RegionLimit.find params[:id]
  end

  def update
    @region_limit = RegionLimit.find params[:id]
    if @region_limit.update region_limit_params
      flash[:notice] = 'Region Limit updated'
      redirect_to admin_competition_checkpoints_path @competition
    else
      flash[:alert] = @region_limit.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def authorise_user!
    @checkpoint = Checkpoint.find params[:checkpoint_id]
    @competition = @checkpoint.competition
    return if current_user.admin_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def region_limit_params
    params.require(:region_limit).permit(
      :region_id,
      :max_national_challenges,
      :max_regional_challenges
    )
  end

  def retrieve_regions
    @regions = @competition.regions
  end
end
