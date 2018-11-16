class Admin::Regions::DataSetsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @region = Region.find(params[:region_id])
    @data_sets = @region.data_sets
  end

  def show
    @region = Region.find(params[:region_id])
    @data_set = DataSet.find(params[:id])
  end

  def new
    @region = Region.find(params[:region_id])
    @data_set = @region.data_sets.new
  end

  def edit
    @region = Region.find(params[:region_id])
    @data_set = DataSet.find(params[:id])
  end

  def create
    create_new_data_set
    if @data_set.save
      flash[:notice] = 'New Data Set Created'
      redirect_to admin_region_data_sets_path(@region)
    else
      flash[:alert] = @data_set.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    update_data_set
    if @data_set.update(data_set_params)
      flash[:notice] = 'Data Set Updated'
      redirect_to admin_region_data_sets_path(@region)
    else
      flash[:alert] = @data_set.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def check_for_privileges
    return if current_user.region_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def data_set_params
    params.require(:data_set).permit(:name, :description, :url)
  end

  def update_data_set
    @region = Region.find(params[:region_id])
    @data_set = DataSet.find(params[:id])
  end

  def create_new_data_set
    @region = Region.find(params[:region_id])
    @data_set = @region.data_sets.new(data_set_params)
    @data_set.competition = Competition.current
  end
end
