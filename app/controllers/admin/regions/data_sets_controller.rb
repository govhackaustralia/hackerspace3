# frozen_string_literal: true

class Admin::Regions::DataSetsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @data_sets = @region.data_sets
  end

  def new
    @data_set = @region.data_sets.new
  end

  def create
    @data_set = @region.data_sets.new data_set_params
    if @data_set.save
      flash[:notice] = 'New Data Set Created'
      redirect_to admin_region_data_sets_path @region
    else
      flash[:alert] = @data_set.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @data_set = DataSet.find params[:id]
  end

  def update
    @data_set = DataSet.find params[:id]
    if @data_set.update data_set_params
      flash[:notice] = 'Data Set Updated'
      redirect_to admin_region_data_sets_path @region
    else
      flash[:alert] = @data_set.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def check_for_privileges
    @region = @competition.regions.find_by_identifier params[:region_id]
    @competition = @region.competition
    return if current_user.region_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def data_set_params
    params.require(:data_set).permit :name, :description, :url
  end
end
